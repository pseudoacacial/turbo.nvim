local watch_dir = require('turbo.watch_dir')

describe("greeting", function()
   it('works!', function()
      assert.combinators.match("Hello Gabo", watch_dir.greeting("Gabo"))
   end)
end)

