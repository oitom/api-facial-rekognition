describe FacialRecognitionController do
  before(:each) do
  end

  after(:each) do
    clean
  end
  
  it 'POST detect_faces' do
    image_data = open_img_fixture('detect-faces-valid')   
    post '/detect-faces', { :photo_image => image_data }
    data = JSON.parse(response.body)
  
    expect(data['face_details'][0]['confidence']).to be > 99
    expect(response.status).to eq(200)
  end

  it 'POST compare_faces' do
    face_origem = open_img_fixture('compare-faces-origem')    
    face_target = open_img_fixture('compare-faces-target')

    post '/compare-faces', { :source_image => face_origem, :target_image => face_target }
    data = JSON.parse(response.body)
  
    expect(data['face_matches'][0]['similarity']).to be > 99
    expect(response.status).to eq(200)
  end

  it 'POST search_faces_in_video' do
    face_origem = open_img_fixture('search-faces-origem')    
    video_target = open_video_fixture('search-faces-target')

    post '/search-faces-in-video', { :source_image => face_origem, :target_video => video_target }
    data = JSON.parse(response.body)
  
    expect(data['persons'][0]['face_matches'][0]["similarity"]).to be > 99
    expect(response.status).to eq(200)
  end

  it 'GET search_faces_in_video' do
    get '/search-faces-in-video', { :job_id => "123"}
    data = JSON.parse(response.body)
  
    expect(data['error']).to eq("Could not find JobId")
    expect(response.status).to eq(200)
  end
end