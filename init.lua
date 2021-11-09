--[[ 
  FRemap      : 키맵핑 라이브러리 (https://github.com/hetima/hammerspoon-foundation_remapping)
  remapper    : 키맵핑 인스턴스
  delay       : mac 입력 기본 지연 시간
  isHyperMode : 하이퍼 모드 여부
 ]]
FRemap = require('foundation_remapping')
remapper = FRemap.new()
delay = hs.eventtap.keyRepeatDelay()
isHyperMode = false

-- 오른쪽 cmd, alt 키맵핑
remapper:remap('rcmd', 'f18'):remap('ralt', 'f19')
remapper:register()

-- 알림 열기
function showAlert(msg, isInfinite) 
  style = {table.unpack(hs.alert.defaultStyle)}
  style.atScreenEdge = 2
  style.textSize = 18
  style.fillColor = {white = 0.05, alpha = 1}
  style.radius = 8
  hs.alert.show(msg, style, isInfinite and 'infinite' or 1.5)
end

-- 알림 닫기
function closeAlert() hs.alert.closeAll() end

-- 하이퍼 모드 모달
hyperMode = hs.hotkey.modal.new()
function hyperMode:entered() showAlert('Hyper mode ON', true) isHyperMode = true end
function hyperMode:exited() showAlert('Hyper mode OFF', false) isHyperMode = false  end

-- 하이퍼 모드 실행/종료 토글
function toggleMode() 
  if isHyperMode then closeAlert() hyperMode:exit() else hyperMode:enter() end
end

-- 키 입력 이벤트
function keyStroke(mode, key)
  return function() hs.eventtap.keyStroke(mode, key, delay) end
end

-- 해머스푼 설정 새로고침
function relad() hs.relad() end

-- 토글 말고 눌렀을 때 모드 활성 때면 비활성
function keyEventHandler (event)
  local keyCode = event:getKeyCode()
  local type = event:getType()
  if keyCode ~= 79 then return end
  if type == 10 and not isHyperMode then toggleMode()
  elseif type == 11 and isHyperMode then toggleMode()
  end
end

keyEventtap = hs.eventtap.new({ 
  hs.eventtap.event.types.keyDown,
  hs.eventtap.event.types.keyUp,
}, keyEventHandler)

-- bootstrap
function bootstrap()
  -- hs.hotkey.bind(nil, 'f18', toggleMode)
  keyEventtap:start()
  showAlert('Hello world!')
end


-- arrow 맵핑
hyperMode:bind({}, 'h', keyStroke({},'Left'), nil, keyStroke({},'Left'))
hyperMode:bind({}, 'l', keyStroke({},'Right'), nil, keyStroke({},"Right"))
hyperMode:bind({}, 'k', keyStroke({},'Up'), nil, keyStroke({},'Up'))
hyperMode:bind({}, 'j',keyStroke({},'Down'), nil, keyStroke({},'Down'))
-- alt + arrow 맵핑
hyperMode:bind({'alt'}, 'h', keyStroke({'alt'},'Left'), nil, keyStroke({'alt'},'Left'))
hyperMode:bind({'alt'}, 'l', keyStroke({'alt'},'Right'), nil, keyStroke({'alt'},"Right"))
hyperMode:bind({'alt'}, 'k', keyStroke({'alt'},'Up'), nil, keyStroke({'alt'},'Up'))
hyperMode:bind({'alt'}, 'j',keyStroke({'alt'},'Down'), nil, keyStroke({'alt'},'Down'))
-- cmd + arrow 맵핑
hyperMode:bind({'cmd'}, 'h', keyStroke({'cmd'},'Left'), nil, keyStroke({'cmd'},'Left'))
hyperMode:bind({'cmd'}, 'l', keyStroke({'cmd'},'Right'), nil, keyStroke({'cmd'},"Right"))
hyperMode:bind({'cmd'}, 'k', keyStroke({'cmd'},'Up'), nil, keyStroke({'cmd'},'Up'))
hyperMode:bind({'cmd'}, 'j',keyStroke({'cmd'},'Down'), nil, keyStroke({'cmd'},'Down'))
-- 해머스푼 리로드 맵핑
hyperMode:bind({}, 'r', hs.reload)

bootstrap()
