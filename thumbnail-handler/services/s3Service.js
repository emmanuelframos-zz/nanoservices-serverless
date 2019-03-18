const AWS = require('aws-sdk')

AWS.config.update({
    region: 'us-east-1'
})

const BUCKET = 'nanoservices-thumbnail-images'

const s3 = new AWS.S3()

const getObject = (bucket, key) => {
    return new Promise((res, rej)=> {
        s3.getObject({
            Bucket: bucket,
            Key: key
        }, (err, data) => {
            if (err) {
                return rej(err);
            }
            return res(data.Body);
        })
    })
}

const putObject = (buffer, fileName) => {   
    return new Promise((res,rej) => {
        s3.putObject({
            Bucket: BUCKET,
            Key: fileName,
            Body: buffer
        }, (err, data) => {
            if (err){
                return rej(err)
            }
            return res({
                bucket: BUCKET,
                key: fileName   
            });
        })
    })
}

module.exports = {
    getObject:getObject,
    putObject:putObject
}