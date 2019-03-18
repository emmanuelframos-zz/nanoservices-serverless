'use strict';

const thumbnailService = require('./services/thumbnailService')

module.exports.thumbnail = async (event) => {
  console.log('SNS event received with success', JSON.stringify(event));
  await thumbnailService.thumbnail(event)  
  return { message: 'Thumbnail generated with success', event };
};
