describe FacialRecognitionController, type: :controller do
  before(:each) do
  end

  after(:each) do
    clean
  end
  
  it 'POST detect_faces' do
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:detect_faces).and_return(payload("detect-faces-valid"))

    image_data = open_img_fixture('detect-faces-valid')   
    post '/detect-faces', { :photo_image => image_data }
    data = JSON.parse(response.body)
    
    expect(data['face_details'][0]['confidence']).to be > 99
    expect(response.status).to eq(200)
  end

  it 'POST compare_faces' do
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:compare_faces).and_return(payload("compare-faces-valid"))

    face_origem = open_img_fixture('compare-faces-origem')    
    face_target = open_img_fixture('compare-faces-target')

    post '/compare-faces', { :source_image => face_origem, :target_image => face_target }
    data = JSON.parse(response.body)
  
    expect(data['face_matches'][0]['similarity']).to be > 99
    expect(response.status).to eq(200)
  end

  it 'POST search_faces_in_video' do
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:create_collection).and_return(payload("create-collection-valid"))
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:index_faces).and_return(payload("index-faces-valid"))
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:start_face_search).and_return(payload("start-face-search-valid"))
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-valid"))

    face_origem = open_img_fixture('search-faces-origem')    
    video_target = open_video_fixture('search-faces-target')

    post '/search-faces-in-video', { :source_image => face_origem, :target_video => video_target }
    data = JSON.parse(response.body)
    
    expect(data['persons'][0]['face_matches'][0]["similarity"]).to be > 99
    expect(response.status).to eq(200)
  end

  it 'GET search_faces_in_video' do
    allow_any_instance_of(Aws::Rekognition::Client).to receive(:get_face_search).and_return(payload("get-face-search-invalid"))

    get '/search-faces-in-video', { :job_id => "123"}
    data = JSON.parse(response.body)
  
    expect(data['error']).to eq("Could not find JobId")
    expect(response.status).to eq(200)
  end
end