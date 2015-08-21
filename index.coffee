_ = require "lodash"
async = require "async"
GoogleSpreadsheet = require "google-spreadsheet"

_getSheetInfo = (sheetId, creds, callback) ->
  sheet = new GoogleSpreadsheet sheetId
  if creds
    async.waterfall [
      (cb) ->
        sheet.useServiceAccountAuth creds, cb
      (cb) ->
        sheet.getInfo cb
    ], callback
  else
    sheet.getInfo callback

_fetchSpreadsheet = (sheetInfo, title, transform, callback) ->
  sheets = _.filter sheetInfo.worksheets, title: title
  async.map sheets, (sheet, cb) ->
    sheet.getRows cb
  , (err, datas) ->
    datas = _.map datas, transform
    if sheets.length is 1
      datas[0]
    else
      datas

#
# sheetId: スプレッドシートのID
# creds: 認証情報（任意）、Googleからもらってくる
# opts: [
#   {
#     title: シート名
#     transform: 列ごとの変形
#   }
# ]
#

module.exports = ({sheetId, creds, opts, callback}) ->
  opts = _.flatten [opts], true
  async.waterfall [
    (cb) ->
      _getSheetInfo sheetId, creds, cb
    (sheetInfo, cb) ->
      async.map (_.map opts), (opt, cb) ->
        _fetchSpreadsheet sheetInfo, opt.title, opt.transform, cb
      , cb
  ], callback
