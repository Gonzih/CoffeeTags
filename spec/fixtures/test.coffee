bump = (wat) ->
  v = 'test'

Wat =
  ho : (x) ->
    x = 'o'
    console.log 'ahhhh'
    @lolWat =
      bump : ->
        console.log 'bump'
      bump_up : ->
        console.log 'bump up'
    @filter = ->
      filter.getElements('input[type="checkbox"]').addEvent('change', (e) ->
        Wat.trackEvent('Track', "Filter::#{e.target.name}",  e.target.value)
      )

loop = (x) ->
  woop = 1
  if z
    fu = 1

  for z in lol
    ugh = 2 * z
