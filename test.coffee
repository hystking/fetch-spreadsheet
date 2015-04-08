test = require "tape"

fetchSpreadsheet = require "./index"
_ = require "lodash"

answer = [{"title":"data1","id":"1","name":"ほげほげ","date":"2014/01/27","value":"0.1"},{"title":"data2","id":"2","name":"ふがふが","date":"2014/01/28","value":"0.2"},{"title":"data3","id":"3","name":"ぴよぴよ","date":"2014/01/29","value":"0.4"},{"title":"data4","id":"4","name":"田中","date":"2020/02/01","value":"3832.4353"},{"title":"data5","id":"5","name":"山田","date":"1999/12/31","value":"0.001"},{"title":"dag4","id":"6","name":"af","date":"2002/02/02","value":"453"},{"title":"423","id":"7","name":"4231","date":"1432/34/34","value":"431"},{"title":"334","id":"8","name":"f","date":"1933/03/03","value":"1234"},{"title":"3","id":"9","name":"3","date":"2003/03/03","value":"3"},{"title":"fd","id":"10","name":"fd","date":"2004/04/04","value":"4444"},{"title":"hoge1","id":"11","name":"3242","date":"2030/01/10","value":"3.111"},{"title":"hoge2","id":"12","name":"sdfgsdfg","date":"sdfgs","value":"dfgs"},{"title":"hoge3","id":"13","name":"33434fdd","date":"dfgsd","value":""}]

test "can fetch correctly", (t) ->
  t.plan 1
  fetchSpreadsheet
    sheetId: "1BUFm75bGUwQs-nMMnXk6XOvLALKCM1ZXmTxTGLTOkrM"
    infos:
      title: "シート1"
      dest: "out.json"
      transform: (data) ->
        (_ data).map (row) -> _.pick row, ["title", "id", "name", "date", "value"]
    callback: ->
      data = require "./out.json"
      t.ok _.isEqual data, answer
