Jets.application.routes.draw do

  post  "/detect-faces",          to: "facial_recognition#detect_faces"
  post  "/compare-faces",         to: "facial_recognition#compare_faces"
  post  "/search-faces-in-video", to: "facial_recognition#search_faces_in_video"
  get   "/search-faces-in-video", to: "facial_recognition#result_faces_in_video"

end
