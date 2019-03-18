'use strict';

const blackwhiteService = require('./services/blackwhiteService')

module.exports.blackwhite = async (event) => {
  console.log('SNS event received with success', JSON.stringify(event));
  await blackwhiteService.blackwhite(event)  
  return { message: 'Black White generated with success', event };
};
