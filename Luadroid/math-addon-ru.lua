local MathModule = {}
MathModule.sort = function(nums, order) -- сортировка
  if order == 1 then
    table.sort(nums)

    print("Сортировка от меньшего к большему\n" .. table.concat(nums, ", "))
  elseif order == -1 then
    table.sort(nums, function(a, b) return a > b end)

    print("Сортировка от большего к меньшему\n" .. table.concat(nums, ", "))
  end

  return nums
end
MathModule.average = function(nums) -- среднее арифметическое
  local sum = 0
  for _, num in ipairs(nums) do
    sum = sum + num
  end
  local result = sum / #nums

  print("Среднее арифметическое ряда чисел " .. table.concat(nums, ", ") .. ":\n" .. result)
  return result
end
MathModule.median = function(nums) -- медиана
  table.sort(nums)
  local len = #nums

  local result = 0
  if len % 2 == 1 then
    result = nums[math.ceil(len / 2)]
  else
    result = (nums[len / 2] + nums[len / 2 + 1]) / 2
  end

  print("Медиана чисел " .. table.concat(nums, ", ") .. ":\n" .. result)
  return result
end
MathModule.range = function(nums) -- размах
  local max = math.max(table.unpack(nums))
  local min = math.min(table.unpack(nums))

  local result = max - min

  print("Размах чисел " .. table.concat(nums, ", ") .. ":\n" .. result)
  return result
end
MathModule.variance = function(nums) -- дисперсия
  local avg = MathModule.average(nums)
  local sum = 0
  for _, num in ipairs(nums) do
    sum = sum + (num - avg) ^ 2
  end
  local result = sum / #nums

  print("Дисперсия чисел " .. table.concat(nums, ", ") .. ":\n" .. result)
  return result
end
MathModule.frequency = function(nums) -- частота
  local freqTable = {}
  for _, num in ipairs(nums) do
    if freqTable[num] then
      freqTable[num] = freqTable[num] + 1
    else
      freqTable[num] = 1
    end
  end

  print("Частота чисел " .. table.concat(nums, ", ") .. ":\n" .. table.concat(freqTable, "\n"))
  return freqTable
end
MathModule.quartiles = function(nums) -- квартиль
  table.sort(nums)
  local len = #nums
  local Q1 = MathModule.median({unpack(nums, 1, math.floor(len / 2))})
  local Q2 = MathModule.median(nums)
  local Q3 = MathModule.median({unpack(nums, math.ceil(len / 2), len)})

  print("Квартиль чисел " .. table.concat(nums, ", ") .. ":\n" .. Q1 .. "\n" .. Q2 .. "\n" .. Q3)
  return Q1, Q2, Q3
end
