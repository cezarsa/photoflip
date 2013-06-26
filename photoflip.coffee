
class PhotoFlip

    minSquare: 80

    constructor: (img) ->
        if img.width == 0 and img.height == 0
            img.onload = (ev) => @init(img)
        else
            @init(img)

    init: (@img) ->
        @img = img
        @totalWidth = img.width
        @totalHeight = img.height
        @placeholder = $('<div class="photoflip-image-placeholder">')
        @placeholder.css({
            width: @totalWidth
            height: @totalHeight
            backgroundColor: $(@img).css('background-color')
        })
        @calculateSquares()
        @createFlippers()
        $(@img).replaceWith(@placeholder)

    calculateSquares: ->
        xSquares = Math.floor(@totalWidth / @minSquare)
        xMod = @totalWidth % @minSquare
        xInc = Math.floor(xMod / xSquares)
        remainderX = xMod % xSquares

        ySquares = Math.floor(@totalHeight / @minSquare)
        yMod = @totalHeight % @minSquare
        yInc = Math.floor(yMod / ySquares)
        remainderY = yMod % ySquares

        @xSizes = []
        @ySizes = []

        for x in [0...xSquares]
            sz = @minSquare + xInc
            sz += 1 if remainderX-- > 0
            @xSizes.push sz

        for y in [0...ySquares]
            sz = @minSquare + yInc
            sz += 1 if remainderY-- > 0
            @ySizes.push sz

    createCanvas: ->
        @canvas = $('<canvas>')[0]
        @canvas.width = @totalWidth
        @canvas.height = @totalHeight
        @ctx = @canvas.getContext('2d')
        @ctx.drawImage(@img, 0, 0)
        @pixelsData = @ctx.getImageData(0, 0, @totalWidth, @totalHeight).data;

    getMeanColor: (offsetX, offsetY, xSz, ySz) ->
        count = 0
        totalR = totalG = totalB = 0
        for y in [offsetY...(ySz + offsetY)]
            for x in [offsetX...(xSz + offsetX)]
                pos = (y * @totalWidth * 4) + (x * 4)
                totalR += @pixelsData[pos]
                totalG += @pixelsData[pos + 1]
                totalB += @pixelsData[pos + 2]
                count++
        
        return [Math.floor(totalR / count), Math.floor(totalG / count), Math.floor(totalB / count)]

    createFlippers: ->
        @createCanvas()

        flips = ['right', 'left', 'top', 'bottom']
        cycleIdx = 0
        
        offsetY = 0
        for ySz in @ySizes
            offsetX = 0
            for xSz in @xSizes
                flipperContainer = $('<div class="photoflip-flipper-container">')
                flipper = $('<div class="photoflip-flipper">')
                flipper.addClass(flips[cycleIdx++])
                cycleIdx %= flips.length
                # flipper.addClass(flips[Math.floor(Math.random() * 4)])

                divFront = $('<div class="photoflip-front photoflip-face">')
                divBack = $('<div class="photoflip-back photoflip-face">')
                color = @getMeanColor(offsetX, offsetY, xSz, ySz)
                flipperContainer.css({
                    width: xSz
                    height: ySz
                })
                divFront.css({
                    backgroundImage: "url(#{@img.src})"
                    backgroundPosition: "-#{offsetX}px -#{offsetY}px"
                })
                divBack.css({
                    backgroundColor: "rgb(#{color[0]}, #{color[1]}, #{color[2]})"
                })
                flipper.append(divFront)
                flipper.append(divBack)
                flipperContainer.append(flipper)
                @placeholder.append(flipperContainer)
                offsetX += xSz
            offsetY += ySz

window.PhotoFlip = PhotoFlip
