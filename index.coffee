_ = require "lodash"
async = require "async"
fs = require "fs"
GoogleSpreadsheet = require "google-spreadsheet"

getSheetInfo = (sheetId, auth, callback) ->
  sheet = new GoogleSpreadsheet sheetId
  if auth
    async.waterfall [
      (cb) ->
        sheet.setAuth auth.username, auth.pass, cb
      (auth, cb) ->
        sheet.getInfo cb
    ], callback
  else
    sheet.getInfo callback

fetchAndSave = (sheetInfo, title, dest, transform, callback) ->
  sheets = _.filter sheetInfo.worksheets, title: title
  async.map sheets, (sheet, cb) ->
    sheet.getRows cb
  , (err, datas) ->
    datas = _.map datas, transform
    if sheets.length is 1
      output = datas[0]
    else
      output = datas
    fs.writeFile dest, (JSON.stringify output, null, "  "), callback

module.exports = ({sheetId, auth, infos, callback}) ->
  infos = _.flatten [infos], true
  async.waterfall [
    (cb) ->
      getSheetInfo sheetId, auth, cb
    (sheetInfo, cb) ->
      async.map (_.map infos), (info, cb) ->
        fetchAndSave sheetInfo, info.title, info.dest, info.transform, cb
      , cb
  ], callback
