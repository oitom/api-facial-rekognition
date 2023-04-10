describe FacialRecognitionService do
  before(:each) do
    
  end

  after(:each) do
    clean
  end

  context 'detect_faces' do
    it 'detect valid' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:detect_faces).and_return(payload("detect-faces-valid"))
      image_data = open_img_fixture('detect-faces-valid')    
      res, status = FacialRecognitionService.new.detect_faces(:photo_image => image_data)
      
      expect(res['face_details'][0]['confidence']).to be > 99
      expect(status).to eq(:ok)
    end

    it 'detect fail' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:detect_faces).and_return(payload("detect-faces-invalid"))
      image_data = open_img_fixture('detect-faces-invalid')
      res, status = FacialRecognitionService.new.detect_faces(:photo_image => image_data)
    
      expect(res[:error]).to eq("No faces detected")
      expect(status).to eq(:ok)
    end
  end

  context 'compare_faces' do
    it 'compare valid' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:compare_faces).and_return(payload("compare-faces-valid"))

      face_origem = open_img_fixture('compare-faces-origem')    
      face_target = open_img_fixture('compare-faces-target')

      res, status = FacialRecognitionService.new.compare_faces(:source_image => face_origem, :target_image => face_target)
      
      expect(res['face_matches'][0]['similarity']).to be > 99
      expect(status).to eq(:ok)
    end

    it 'compare fail' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:compare_faces).and_return(payload("compare-faces-invalid"))

      face_origem = open_img_fixture('compare-faces-origem')    
      face_target = open_img_fixture('compare-faces-target-invalid')

      res, status = FacialRecognitionService.new.compare_faces(:source_image => face_origem, :target_image => face_target)
      
      expect(res['unmatched_faces'][0]['confidence']).to be > 99
      expect(status).to eq(:ok)
    end

  end

  context 'search_faces_in_video' do
    it 'Successfully found face between image and video' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:create_collection).and_return(payload("create-collection-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:index_faces).and_return(payload("index-faces-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:start_face_search).and_return(payload("start-face-search-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-valid"))

      face_origem = open_img_fixture('search-faces-origem')    
      video_target = open_video_fixture('search-faces-target')

      res, status = FacialRecognitionService.new.search_faces_in_video(:source_image => face_origem, :target_video => video_target)
      
      expect(res['persons'][0]['face_matches'][0]["similarity"]).to be > 99
      expect(status).to eq(:ok)
    end

    it 'Not found face similarity between image and video' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:create_collection).and_return(payload("create-collection-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:index_faces).and_return(payload("index-faces-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:start_face_search).and_return(payload("start-face-search-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-nomatch"))

      face_origem = open_img_fixture('compare-faces-origem')    
      video_target = open_video_fixture('search-faces-target')

      res, status = FacialRecognitionService.new.search_faces_in_video(:source_image => face_origem, :target_video => video_target)
      
      expect(res['persons'][0]['face_matches'][0]).to eq(nil)
      expect(status).to eq(:ok)
    end
  end

  context 'result_faces_in_video' do
    it 'Result not found job id' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-invalid"))

      job_id = "123"
      res, status = FacialRecognitionService.new.result_faces_in_video(:job_id => job_id)
      
      expect(res['error']).to eq("Could not find JobId")
      expect(status).to eq(:ok)
    end

    it 'Not found face similarity between image and video' do
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:create_collection).and_return(payload("create-collection-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:index_faces).and_return(payload("index-faces-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:start_face_search).and_return(payload("start-face-search-valid"))
      allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-inprogress"))

      face_origem = open_img_fixture('compare-faces-origem')
      video_target = open_video_fixture('search-faces-target')

      res, status = FacialRecognitionService.new.search_faces_in_video(:source_image => face_origem, :target_video => video_target, :notify => true)
      res, status = FacialRecognitionService.new.result_faces_in_video(:job_id => res[:job_id])
      
       expect(res['job_status']).to eq("IN_PROGRESS")
      expect(status).to eq(:ok)
    end
  end
end