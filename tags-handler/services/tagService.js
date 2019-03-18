const rekognitionService = require('./rekognitionService')
const sqsService = require('./sqsService')

const tag = async event => {
  const s3Info = JSON.parse(event.Records[0].Sns.Message)
  const bucket = s3Info.Records[0].s3.bucket.name
  const key = s3Info.Records[0].s3.object.key  

  const labels = await rekognitionService.detectLabels(bucket, key);
  
  const item = {
      key: key,
      labels: labels,
      eventType: 'TAG_EVENT'
  }

  await sqsService.putMessage(item)
}

module.exports = {
    tag:tag
}