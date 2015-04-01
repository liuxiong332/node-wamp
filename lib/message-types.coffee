
exports.messageDef =
  'HELLO': [['realm', 'uri'], ['details', 'dict']]
  'WELCOME': [['session.id', 'id'], ['details', 'dict']]
  'ABORT': [['details', 'dict'], ['reason', 'uri']]
  'CHALLENGE': []
  'AUTHENTICATE': []
  'GOODBYE': [['details', 'dict'], ['reason', 'uri']]
  'HEARTBEAT': []
  'ERROR': [['request.type', 'typekey'], ['request.id', 'id'], ['details', 'dict'], ['error', 'uri'], ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]
  'PUBLISH': [['request.id', 'id'], ['options', 'dict'], ['topic', 'uri'], ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]
  'PUBLISHED': [['publish.request.id', 'id'], ['publication.id', 'id']]
  'SUBSCRIBE': [['request.id', 'id'], ['options', 'dict'], ['topic', 'uri']]
  'SUBSCRIBED': [['subscribe.request.id', 'id'], ['subscription.id', 'id']]
  'UNSUBSCRIBE': [['request.id', 'id'], ['subscribed.subscription.id', 'id']]
  'UNSUBSCRIBED': [['unsubscribe.request.id', 'id']]
  'EVENT': [['subscribed.subscription.id', 'id'], ['published.publication.id', 'id'], ['details', 'dict'], ['publish.args', 'list', {optional: true}], ['publish.kwargs', 'dict', {optional: true}]]
  'CALL': [['request.id', 'id'], ['options', 'dict'], ['procedure', 'uri'], ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]
  'CANCEL': []
  'RESULT': [['call.request.id', 'id'], ['options', 'dict'], ['yield.args', 'list', {optional: true}], ['yield.kwargs', 'dict', {optional: true}]]
  'REGISTER': [['request.id', 'id'], ['options', 'dict'], ['procedure', 'uri']]
  'REGISTERED': [['register.request.id', 'id'], ['registration.id', 'id']]
  'UNREGISTER': [['request.id', 'id'], ['registered.registration.id', 'id']]
  'UNREGISTERED': [['unregister.request.id', 'id']]
  'INVOCATION': [['request.id', 'id'], ['registered.registration.id', 'id'], ['details', 'dict'], ['call.args', 'list', {optional: true}], ['call.kwargs', 'dict', {optional: true}]]
  'INTERRUPT': []
  'YIELD': [['invocation.request.id', 'id'], ['options', 'dict'], ['args', 'list', {optional: true}], ['kwargs', 'dict', {optional: true}]]

exports.messageTypeMap =
  1: 'HELLO'
  2: 'WELCOME'
  3: 'ABORT'
  4: 'CHALLENGE'
  5: 'AUTHENTICATE'
  6: 'GOODBYE'
  8: 'ERROR'
  16:	'PUBLISH'
  17:	'PUBLISHED'
  32:	'SUBSCRIBE'
  33:	'SUBSCRIBED'
  34:	'UNSUBSCRIBE'
  35:	'UNSUBSCRIBED'
  36:	'EVENT'
  48:	'CALL'
  49:	'CANCEL'
  50:	'RESULT'
  64:	'REGISTER'
  65:	'REGISTERED'
  66:	'UNREGISTER'
  67:	'UNREGISTERED'
  68:	'INVOCATION'
  69:	'INTERRUPT'
  70:	'YIELD'
