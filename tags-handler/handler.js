'use strict';

const tagService = require('./services/tagService')

module.exports.tag = async (event) => {
  console.log('SNS event received with success', JSON.stringify(event));
  await tagService.tag(event)  
  return { message: 'Tag generated with success', event };
};