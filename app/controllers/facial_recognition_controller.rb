class FacialRecognitionController < ApplicationController

  # POST /detect-faces
  def detect_faces
    service = FacialRecognitionService.new
    data, code = service.detect_faces(detect_faces_params)

    render json: data, status: :ok
  end  

  # POST /compare-faces
  def compare_faces
    service = FacialRecognitionService.new
    data, code = service.compare_faces(compare_faces_params)

    render json: data, status: :ok
  end  

  # POST /search-faces-in-video
  def search_faces_in_video
    service = FacialRecognitionService.new
    data, code = service.search_faces_in_video(search_faces_in_video_params)
    
    render json: data, status: :ok
  end
  
  # GET /search-faces-in-video
  def result_faces_in_video
    service = FacialRecognitionService.new
    data, code = service.result_faces_in_video(result_faces_in_video_params)
    
    render json: data, status: :ok
  end

  private
    def detect_faces_params
      params.permit(:photo_image)
    end

    def compare_faces_params
      params.permit(:source_image, :target_image)
    end

    def search_faces_in_video_params
      params.permit(:source_image, :target_video, :notify)
    end

    def result_faces_in_video_params
      params.permit(:job_id)
    end
end
  
  