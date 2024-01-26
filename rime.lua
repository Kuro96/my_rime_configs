time_translator = require("time")
date_translator = require("date")
week_translator = require("week")
number_translator = require("number_translator")
code_length_limit_processor = require("code_limit")
-- 降低部分英语单词在候选项的位置，可在方案中配置要降低的单词
reduce_english_filter = require("reduce_english_filter")
-- 错音错字提示
corrector = require("corrector")
-- 中国农历
Chinese_lunar_calendar = require("chineseLunarCalendar")
--- 过滤器：单字在先
function single_char_first_filter(input)
   local l = {}
   for cand in input:iter() do
      if (utf8.len(cand.text) == 1) then
         yield(cand)
      else
         table.insert(l, cand)
      end
   end
   for i, cand in ipairs(l) do
      yield(cand)
   end
end
