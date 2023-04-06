# API Facial Recognition


API deep learning based on image and video analysis service for facial and object recognition.

**`Ruby on Jets`**
**`AWS Rekognition`**
**`AWS S3`**
**`AWS SQS`**
**`AWS SNS`**

## API Documentation

#### **Detect Faces**

```http
  POST /detect-faces
```

| Param   | Type       | Description                           |
| :---------- | :--------- | :---------------------------------- |
| `photo_image` | `base64` | A photo to be dectado a face. ***Required***. |

##### Response:
``` 
{
    "face_details": [ 
        { 
            "bounding_box": {},
            "age_range": {
                "low": 24,
                "high": 34
            },
            "smile": {
                "value": true,
                "confidence": 95.7833023071289
            },
            "gender": {
                "value": "Male",
                "confidence": 99.81163787841797
            },
            "emotions": [
                {
                    "type": "HAPPY",
                    "confidence": 99.44390106201172
                }
            ],
            "quality": {
                "brightness": 93.36430358886719,
                "sharpness": 92.22801208496094
            },
            "confidence": 99.99968719482422
        }
    ]
} 
```

See mor at: [API_DetectFaces](https://docs.aws.amazon.com/rekognition/latest/APIReference/API_DetectFaces.html)


#### **Compare faces**

```http
  POST /compare-faces
```

| Param   | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `source_image` | `base64` | A face photo to be used as a source. ***Required***|
| `target_image` | `base64` | A face photo to be used as a target.  ***Required***.|

##### Response:
``` 
{
    "source_image_face": {
        "bounding_box": {},
        "confidence": 99.99678039550781
    },
    "face_matches": [
        {
            "similarity": 99.99971008300781,
            "face": {
                "bounding_box": {},
                "confidence": 99.9969253540039,
                "landmarks": [],
                "pose": {},
                "quality": {}
            }
        }
    ],
    "unmatched_faces": []
}
```
See mor at: [API_CompareFaces](https://docs.aws.amazon.com/rekognition/latest/APIReference/API_CompareFaces.html)


#### **Start Face Detection**

```http
  POST /search-faces-in-video
```

| Param   | Type       | Description                                   |
| :---------- | :--------- | :------------------------------------------ |
| `source_image` | `base64` | A face photo to be used as a source. ***Required***|
| `target_video` | `base64` | A video to be used as a target.  ***Required***.|

##### Response:
``` 
{
    "job_status": "SUCCEEDED",
    "next_token": "sQZ4pUQ5c8TI...",
    "video_metadata": {
        "codec": "h264",
        "duration_millis": 4766,
        "format": "QuickTime / MOV",
        "frame_rate": 30.0,
        "frame_height": 480,
        "frame_width": 852,
        "color_range": "LIMITED"
    },
    "persons": [
        {
            "timestamp": 0,
            "person": {
                "index": 0,
                "face": {
                    "bounding_box": {},
                    "landmarks": [],
                    "pose": {},
                    "quality": {},
                    "confidence": 99.9998550415039
                }
            },
            "face_matches": [
                {
                    "similarity": 99.99674987792969,
                    "face": {
                        "face_id": "72a2f0df-d6f9...",
                        "bounding_box": {},
                        "image_id": "cdc0eaa2-465a...",
                        "external_image_id": "2af784f0-b6d1...",
                        "confidence": 99.98380279541016
                    }
                }
            ]
        }
    ]
}
```
See mor at: [API_StartFaceDetection](https://docs.aws.amazon.com/rekognition/latest/APIReference/API_StartFaceDetection.html)

## Environment Variables

To run this project, you will need to add the following environment variables to your .env


`AWS_REGION`
`AWS_ACCESS_KEY_ID`
`AWS_SECRET_ACCESS_KEY`
`BUCKET_NAME`


## Installation

Install and run api-facial-rekognition with a ruby on jets

```bash
  cd api-facial-rekognition
  bundle install
  bundle exec jets s
```
    
## Reference

 - [Amazon Rekognition Documentation](https://docs.aws.amazon.com/rekognition/index.html)
- [How to use AWS Rekognition Ruby](https://medium.com/@codingInformer/how-to-use-aws-rekognition-using-ruby-on-rails-a5ad545bd750)
## 🚀 Authors

- [@oitom](https://github.com/oitom)

