const jimp = require('jimp')

const s3Service = require('./s3Service')

const sqsService = require('./sqsService')

const thumbnail = async event  => {
    const s3Info = JSON.parse(event.Records[0].Sns.Message)
    const bucket = s3Info.Records[0].s3.bucket.name
    const key = s3Info.Records[0].s3.object.key
    const objectS3 = await s3Service.getObject(bucket, key)
    const image = await jimp.read(objectS3)
    const buffer = await image.resize(100, 100).quality(80).getBufferAsync(jimp.MIME_JPEG)
    const thumbnailData = await s3Service.putObject(buffer, key);
    thumbnailData.eventType = 'THUMBNAIL_EVENT'
    await sqsService.putMessage(thumbnailData)
}

module.exports = {
    thumbnail:thumbnail
}
