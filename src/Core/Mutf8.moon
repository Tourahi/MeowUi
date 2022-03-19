----
-- Adds UTF-8 functions to string lua table.
-- @module Mutf8

--- refs
-- https://www.utf8-chartable.de/unicode-utf8-table.pl?number=1024&utf8=dec
-- https://en.wikipedia.org/wiki/UTF-8

string = string

ONE_BYTE = 1
TWO_BYTE = 2
THREE_BYTE = 3
FOUR_BYTE = 4


with string
  .utf8charbytes = (str, i = 1) ->
    assert type(str) == "string",
      "bad argument #1 to 'utf8charbytes' (string expected, got ".. type(str).. ")"
    
    assert type(i) == "number",
      "bad argument #2 to 'utf8charbytes' (number expected, got ".. type(i).. ")"

    -- Numeric representation
    numRepByteOne = str\byte(i)

    -- Determine bytes needed for char [ RFC 3629 ]
    -- first Byte
    if numRepByteOne > 0 and numRepByteOne <= 127 then return ONE_BYTE
    elseif numRepByteOne >= 194 and numRepByteOne <= 223
      local numRepByteTwo

      numRepByteTwo = str\byte(i + ONE_BYTE)

      assert numRepByteTwo ~= nil, "UTF-8 string terminated early"

      -- second byte
      if numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      return TWO_BYTE

    elseif numRepByteOne >= 224 and numRepByteOne <= 239
      local numRepByteTwo
      local numRepByteThree

      numRepByteTwo, numRepByteThree = str\byte(i + ONE_BYTE), str\byte(i + TWO_BYTE)

      assert (numRepByteTwo ~= nil and numRepByteThree ~= nil), "UTF-8 string terminated early"

      -- second byte
      if numRepByteOne == 224 and (numRepByteTwo < 160 or numRepByteTwo > 191) then error "Invalid UTF-8 character"
      elseif numRepByteOne == 237 and (numRepByteTwo < 128 or numRepByteTwo > 159) then error "Invalid UTF-8 character"
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      -- third byte
      if numRepByteThree < 128 or numRepByteThree > 191 then error "Invalid UTF-8 character"

      return THREE_BYTE

    elseif numRepByteOne >= 240 and numRepByteOne <= 244
      local numRepByteTwo
      local numRepByteThree
      local numRepByteFour

      numRepByteTwo, numRepByteThree, numRepByteFour = str\byte(i + ONE_BYTE), str\byte(i + TWO_BYTE), str\byte(i + THREE_BYTE)

      assert (numRepByteTwo ~= nil and numRepByteThree ~= nil and numRepByteFour ~= nil), "UTF-8 string terminated early"

      -- second byte
      if numRepByteOne == 240 and (numRepByteTwo < 144 or numRepByteTwo > 191) then error "Invalid UTF-8 character"
      elseif numRepByteOne == 244 and (numRepByteTwo < 128 or numRepByteTwo > 143) then error "Invalid UTF-8 character"
      elseif numRepByteTwo < 128 or numRepByteTwo > 191 then error "Invalid UTF-8 character"

      -- third byte
      if numRepByteThree < 128 or numRepByteThree > 191 then error "Invalid UTF-8 character"

      -- fourth byte
      if numRepByteFour < 128 or numRepByteFour > 191 then error "Invalid UTF-8 character"

      return FOUR_BYTE

    else
      error "Invalid UTF-8 character"