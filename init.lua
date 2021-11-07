-- 오른쪽 cmd, alt 키맵핑
local FRemap = require('foundation_remapping')
local remapper = FRemap.new()
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
local isHyperMode = false
hyperMode = hs.hotkey.modal.new()
function hyperMode:entered() showAlert('Hyper mode ON', true) isHyperMode = true end
function hyperMode:exited() showAlert('Hyper mode OFF', false) isHyperMode = false  end

-- 하이퍼 모드 실행/종료 토글
function toggleMode() 
  if isHyperMode then closeAlert() hyperMode:exit() else hyperMode:enter() end
end


-- 키 이벤트
local delay = hs.eventtap.keyRepeatDelay()
function keyStroke(mode, key)
  return function() hs.eventtap.keyStroke(mode, key, delay) end
end

-- 해머스푼 리로드
function relad() hs.relad() end

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
-- 해머스푼 리로드 맵핑
hyperMode:bind({}, 'r', hs.reload)


function bootstrap()
  hs.hotkey.bind(nil, 'f18', toggleMode)
  showAlert('Hello world!')
end

bootstrap()
