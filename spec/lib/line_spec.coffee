describe 'Morris.Line', ->

  beforeEach ->
    placeholder = $('<div id="graph" style="width: 100px; height: 50px"></div>')
    $('#test').append(placeholder)

  afterEach ->
    $('#test').empty()

  it 'should not alter user-supplied data', ->
    my_data = [{x: 1, y: 1}, {x: 2, y: 2}]
    expected_data = [{x: 1, y: 1}, {x: 2, y: 2}]
    Morris.Line
      element: 'graph'
      data: my_data
      xkey: 'x'
      ykeys: ['y']
      labels: ['dontcare']
    my_data.should.deep.equal expected_data

  it 'should raise an error when the placeholder element is not found', ->
    my_data = [{x: 1, y: 1}, {x: 2, y: 2}]
    fn = ->
      Morris.Line(
        element: "thisplacedoesnotexist"
        data: my_data
        xkey: 'x'
        ykeys: ['y']
        labels: ['dontcare']
      )
    fn.should.throw(/Graph placeholder not found./)

  it 'should make point styles customizable', ->
    my_data = [{x: 1, y: 1}, {x: 2, y: 2}]
    red = '#ff0000'
    blue = '#0000ff'
    chart = Morris.Line
      element: 'graph'
      data: my_data
      xkey: 'x'
      ykeys: ['y']
      labels: ['dontcare']
      pointStrokeColors: [red, blue]
      pointWidths: [1, 2]
      pointFillColors: [null, red]
    chart.strokeWidthForSeries(0).should.equal 1
    chart.strokeForSeries(0).should.equal red
    chart.strokeWidthForSeries(1).should.equal 2
    chart.strokeForSeries(1).should.equal blue
    (null == chart.pointFillColorForSeries(0)).should.be
    (chart.pointFillColorForSeries(0) || chart.colorForSeries(0)).should.equal chart.colorForSeries(0)
    chart.pointFillColorForSeries(1).should.equal red

  describe 'generating column labels', ->

    it 'should use user-supplied x value strings by default', ->
      chart = Morris.Line
        element: 'graph'
        data: [{x: '2012 Q1', y: 1}, {x: '2012 Q2', y: 1}]
        xkey: 'x'
        ykeys: ['y']
        labels: ['dontcare']
      chart.columnLabels.should == ['2012 Q1', '2012 Q2']

    it 'should use a default format for timestamp x-values', ->
      d1 = new Date(2012, 0, 1)
      d2 = new Date(2012, 0, 2)
      chart = Morris.Line
        element: 'graph'
        data: [{x: d1.getTime(), y: 1}, {x: d2.getTime(), y: 1}]
        xkey: 'x'
        ykeys: ['y']
        labels: ['dontcare']
      chart.columnLabels.should == [d2.toString(), d1.toString()]

    it 'should use user-defined formatters', ->
      d = new Date(2012, 0, 1)
      chart = Morris.Line
        element: 'graph'
        data: [{x: d.getTime(), y: 1}, {x: '2012-01-02', y: 1}]
        xkey: 'x'
        ykeys: ['y']
        labels: ['dontcare']
        dateFormat: (d) ->
          x = new Date(d)
          "#{x.getYear()}/#{x.getMonth()+1}/#{x.getDay()}"
      chart.columnLabels.should == ['2012/1/1', '2012/1/2']
