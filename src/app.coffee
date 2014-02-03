class @MuchoLOL
  constructor: (@el) ->
    @width = window.innerWidth
    @height = window.innerHeight
    @color = '#000'
    
    window.addEventListener 'viewportchanged', @onViewportChange
    @paths = []
    @paths.push @path 'L', 0
    @paths.push @path 'O', 1/3 - 0.015
    @paths.push @path 'L', 2/3
    console.log @paths
    @render()
  
  onViewportChange: (e) =>
    @width = e.width
    @height = e.height
    @render()
  
  path: (char, offset) ->
    marginX = 0.01
    marginY = 0.02
    strokeW = 0.08
    strokeH = 0.15
    letterWidth = 1/3 - marginX*2
    
    top = marginY
    bottom = 1 - marginY
    left = 0 + offset + marginX
    right = letterWidth + left
    
    avg = ->
      args = []
      for arg in arguments
        args.push arg
      args.reduce((sum,n) -> sum+n)/arguments.length
    
    path = []
    switch char
      when 'L'
        stemRight = strokeW + left
        barTop = bottom - strokeH
        
        path.push [left, top]
        path.push [stemRight, top]
        path.push [stemRight, barTop]
        path.push [right, barTop]
        path.push [right, bottom]
        path.push [left, bottom]
        path.push [left, top]
        path
      when 'O'
        innerLeft = left + strokeW
        innerRight = right - strokeW
        innerTop = top + strokeH
        innerBottom = bottom - strokeH
        cx = (right + left) / 2
        cy = (bottom + top) / 2
        
        path.push [cx, top]
        path.push [right, cy, avg(cx,right,right), top, right, avg(cy,top)]
        path.push [cx, bottom, right, avg(cy,bottom), avg(cx,right,right), bottom]
        path.push [left, cy, avg(cx,left,left), bottom, left, avg(cy,bottom)]
        path.push [cx, top, left, avg(cy,top), avg(cx,left,left), top]
        path.push [cx, innerTop]
        path.push [innerLeft, cy, avg(cx,innerLeft,innerLeft), innerTop, innerLeft, avg(cy,innerTop)]
        path.push [cx, innerBottom, innerLeft, avg(cy,innerBottom), avg(cx,innerLeft,innerLeft), innerBottom]
        path.push [innerRight, cy, avg(cx,innerRight,innerRight), innerBottom, innerRight, avg(cy,innerBottom)]
        path.push [cx, innerTop, innerRight, avg(cy,innerTop), avg(cx,innerRight,innerRight), innerTop]
        path
      else
        throw Error "Unsupported character '#{char}'"
  
  render: ->
    @el.width = @width
    @el.style.width = "#{@width}px"
    @el.height = @height
    @el.style.height = "#{@height}px"
    
    ctx = @el.getContext '2d'
    ctx.clearRect 0, 0, @width, @height
    
    ctx.fillStyle = @color
    
    for path in @paths
      console.log 'path', path
      ctx.beginPath()
      console.log 'ctx.moveTo', path[0][0]*@width, path[0][1]*@height
      ctx.moveTo path[0][0]*@width, path[0][1]*@height
      for i in [1..path.length-1]
        point = path[i]
        x = point[0] * @width
        y = point[1] * @height
        if point.length == 4
          cx = point[2] * @width
          cy = point[3] * @height
          cx1 = 
          ctx.bezierCurveTo cx, cy, cx, cy, x, y
          console.log i, 'ctx.bezierCurveTo', cx, cy, cx, cy, x, y
        else if point.length == 6
          cx1 = point[2] * @width
          cy1 = point[3] * @height
          cx2 = point[4] * @width
          cy2 = point[5] * @height
          ctx.bezierCurveTo cx1, cy1, cx2, cy2, x, y
          console.log i, 'ctx.bezierCurveTo', cx1, cy1, cx2, cy2, x, y
        else
          ctx.lineTo x, y
          console.log i, 'ctx.lineTo', x, y
      ctx.fill()

module.exports = @MuchoLOL
