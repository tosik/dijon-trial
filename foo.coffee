dijon = module.require('dijon/dist/dijon.min.js')
$ = require 'jquery'

p = console.log


class Mediator
  view: null

class FooViewMediator extends Mediator
  onRegister: () ->
    p 'registered'
    @view.talk()

  onRemove: () ->
    p 'removed'

class FooView
  talk: () -> p 'hello'


class MediatorInjector
  mediators: {}

  constructor: ->
    @system = new dijon.System()
    @system.mapOutlet('view');

  registerView: (view) ->
    @system.mapValue('view', view)

  getMediatorName: (view) ->
    view.constructor.name + "Mediator"

  addView: (view) ->
    @registerView(view)
    mediator = new(eval @getMediatorName(view))
    @system.injectInto(mediator)
    mediator.onRegister?()
    @mediators[view] = mediator

  removeView: (view) ->
    mediator = @mediators[view]
    @mediators[view] = null
    mediator.onRemove?()


injector = new MediatorInjector()
foo = new FooView
injector.addView(foo)
injector.removeView(foo)
