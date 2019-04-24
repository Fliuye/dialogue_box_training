-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- local updateTextListener
local addTextListener

testTextOptions = {
  text = "This is a test text box to see what happens if I slowly add this text to another string.",
  x = 0,
  y = 0
}

local testText = display.newText( testTextOptions )

function createTextBox( x, y, width, height )
  local textBoxGroup = display.newGroup()
  local newBox = display.newRect( x, y, width, height )
  local newTextOptions =
  {
    text = "",
    x = newBox.x - newBox.width / 2 + newBox.width / 32,
    y = newBox.y - newBox.height / 2 + newBox.height / 12,
    width = newBox.width - newBox.width / 24,
    -- font = ,
    -- fontSize = ,
  }
  local newText = display.newText( newTextOptions )
  newText:setFillColor( 0.2, 0.2, 0.2, 1.0 )
  newText.currentIndex = 1;
  newText.anchorY = 0
  newText.anchorX = 0
  textBoxGroup.newBox = newBox;
  textBoxGroup.newText = newText;
  textBoxGroup:insert( newBox );
  textBoxGroup:insert( newText );
  return textBoxGroup;
end

function returnNextWord( _text, _index )
  if ( not _index ) then
    _index = 1;
  end
  for word in string.gmatch( _text, "%S+", _index ) do
    return word;
  end
end

function checkWidthOfNextWord()

end

function addTextListener( newText, testText )
  local function updateTextListener( event )
    local currentIndex = newText.currentIndex;
    local indexMax = testText:len();
    newText.text = string.sub( testText, 1, currentIndex )
    newText.currentIndex = currentIndex + 1;
    if ( newText.currentIndex > indexMax ) then
      newText.currentIndex = indexMax;
    end
    local checkNextWord = display.newText( { x = 0, y = 0, text = "" } )
    local currentText = string.sub( testText, newText.currentIndex, testText:len())
    local nextWord = returnNextWord( currentText, newText.currentIndex )
    if ( nextWord ~= newText.previousWord ) then
      checkNextWord.text = newText.text..nextWord;
      if ( checkNextWord.width > newText.width ) then
        local beginIndex, endIndex = string.find( testText, nextWord )
        local firstHalf = string.sub( testText, 1, beginIndex - 1 )
        local secondHalf = string.sub( testText, beginIndex, testText:len())
        testText = firstHalf.."\r"..secondHalf;
      end
      newText.previousWord = nextWord;
      checkNextWord:removeSelf();
    else
      newText.previousWord = nextWord;
    end
    if ( newText.text == testText ) then
      timer.cancel( newText.timerReference )
    end
  end
  return updateTextListener
end

local textGroup = createTextBox( display.contentWidth / 2, 3 * display.contentHeight / 4, display.contentWidth, display.contentHeight / 4 )
textGroup.newText.updateTextListener = addTextListener( textGroup.newText, testText.text )
local speed = 20;
textGroup.newText.timerReference = timer.performWithDelay( speed, textGroup.newText.updateTextListener, 0 )

-- needs a check to see if a word will go to the next line ( if it does, skip down to the next line with  "\n"))
