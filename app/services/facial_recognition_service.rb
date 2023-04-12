class FacialRecognitionService 
  
  def detect_faces(params = {})
    photo = upload_s3(params[:photo_image])

    attrs = {
      image: {
        s3_object: {
          bucket: ENV["BUCKET_NAME"],
          name: photo
        },
      },
      attributes: ['ALL']
    }
    response = reko_client.detect_faces attrs
    response = JSON.parse(response.to_json)
    
    return [{ error: 'No faces detected', face_details: [] }, :ok] if response['face_details'].nil? || response['face_details'].empty?
    return [response, :ok]
  end

  def compare_faces(params = {})
    source_image = upload_s3(params[:source_image])
    target_image = upload_s3(params[:target_image])

    attrs = {
      source_image: {
        s3_object: {
          bucket: ENV["BUCKET_NAME"],
          name: source_image
        },
      },
      target_image: {
        s3_object: {
          bucket: ENV["BUCKET_NAME"],
          name: target_image
        },
      },
      similarity_threshold: 70.0
    }
    response = reko_client.compare_faces attrs

    return [response, :ok]
  end

  def search_faces_in_video(params = {})
    source_image = upload_s3(params[:source_image])
    video = upload_s3(params[:target_video], 'video')
    
    collection_id = create_collection
    create_index_face(collection_id, source_image)
    response = start_face_search(video, collection_id)
        
    response = JSON.parse(response.to_json)
    job_id = response["job_id"]
    
    if params[:notify] == true
      return [{job_id: job_id}, :ok]
    else
      loop do
        sleep(5)
        response = get_face_search(job_id)
        if response['job_status'] == 'SUCCEEDED' || response['job_status'] == 'FAILED'
          return [response, :ok]
        end
        
      end      
    end
  end

  def result_faces_in_video(params= {})
    response = get_face_search(params[:job_id])
    response = JSON.parse(response.to_json)
    return [response, :ok]
  rescue Aws::Rekognition::Errors::ResourceNotFoundException => e
    return [{ error: e.message }, :ok]
  end

  private
    def upload_s3(photo_image, type = 'image')
      if type == 'image'
        source_data = Base64.decode64(photo_image['data:image/jpeg;base64,'.length .. -1]) 
        name_file = "#{UUID.new.generate}.jpg"         
      else
        source_data = Base64.decode64(photo_image['data:video/mp4;base64,'.length .. -1]) 
        name_file = "#{UUID.new.generate}.mp4"         
      end

      s3 = Aws::S3::Client.new()
      s3.put_object({
        body: source_data,
        bucket: ENV["BUCKET_NAME"],
        key:  name_file,
      })

      name_file
    end

    def reko_client
      aws_reko = Aws::Rekognition::Client.new(
        region: 'us-east-1',
        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def create_collection
      collection_id = UUID.new.generate
      resp_collection = reko_client.create_collection({
        collection_id: collection_id
      })
      collection_id
    end

    def create_index_face(collection_id, source_image)
      response = reko_client.index_faces({
        collection_id: collection_id, 
        detection_attributes: [
        ], 
        external_image_id: UUID.new.generate, 
        image: {
          s3_object: {
            bucket: ENV["BUCKET_NAME"], 
            name: source_image, 
          }, 
        }, 
      })
    end

    def start_face_search(video, collection_id)
      response = reko_client.start_face_search({
        video: { 
          s3_object: {
            bucket: ENV["BUCKET_NAME"],
            name: video
          },
        },
        client_request_token: UUID.new.generate,
        face_match_threshold: 1.0,
        collection_id: collection_id,
        notification_channel: {
          sns_topic_arn: "arn:aws:sns:us-east-1:876426640720:videos-rekognition.fifo",
          role_arn: "arn:aws:iam::876426640720:role/RoleRekognition",
        },
        job_tag: "video_rekognition",
      })
      response
    end

    def get_face_search(job_id)
      response = reko_client.get_face_search({
        job_id: job_id,
        max_results: 1,
        sort_by: "INDEX"
      })
      response
    end
end