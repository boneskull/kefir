{stream, prop, send, Kefir} = require('../test-helpers.coffee')



describe 'flatten', ->


  describe 'stream', ->

    it 'should return stream', ->
      expect(stream().flatten ->).toBeStream()

    it 'should activate/deactivate source', ->
      a = stream()
      expect(a.flatten ->).toActivate(a)

    it 'should be ended if source was ended', ->
      expect(send(stream(), ['<end>']).flatten ->).toEmit ['<end:current>']

    it 'should handle events', ->
      a = stream()
      expect(
        a.flatten (x) -> if x > 1 then [1..x] else []
      ).toEmit [1, 2, {error: 4}, 1, 2, 3, '<end>'], ->
        send(a, [1, 2, {error: 4}, 3, '<end>'])

    it 'if no `fn` provided should use the `id` function by default', ->
      a = stream()
      expect(a.flatten()).toEmit [1, 2, 3, '<end>'], ->
        send(a, [[1], [], [2, 3], '<end>'])



  describe 'property', ->

    it 'should return stream', ->
      expect(prop().flatten ->).toBeStream()

    it 'should activate/deactivate source', ->
      a = prop()
      expect(a.flatten ->).toActivate(a)

    it 'should be ended if source was ended', ->
      expect(send(prop(), ['<end>']).flatten ->).toEmit ['<end:current>']

    it 'should handle events (handler skips current)', ->
      a = send(prop(), [1])
      expect(
        a.flatten (x) -> if x > 1 then [1..x] else []
      ).toEmit [1, 2, {error: 4}, 1, 2, 3, '<end>'], ->
        send(a, [2, {error: 4}, 3, '<end>'])

    it 'should handle current correctly', ->
      expect(
        send(prop(), [1]).flatten (x) -> [x]
      ).toEmit [{current: 1}]
      expect(
        send(prop(), [{error: 0}]).flatten ->
      ).toEmit [{currentError: 0}]

    it 'should handle multiple currents correctly', ->
      expect(
        send(prop(), [2]).flatten (x) -> [1..x]
      ).toEmit [{current: 1}, {current: 2}]
