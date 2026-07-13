_:

{
  services.inputplumber.enable = true;

  environment.etc."inputplumber/profiles/default.yaml".text = ''
    version: 1
    kind: DeviceProfile
    name: Kamo desktop controls
    description: ROG Ally controls for the Niri desktop

    target_devices:
      - mouse
      - keyboard

    mapping:
      # D-pad: arrow keys
      - name: Arrow up
        source_event:
          gamepad:
            button: DPadUp
        target_events:
          - keyboard: KeyUp
      - name: Arrow down
        source_event:
          gamepad:
            button: DPadDown
        target_events:
          - keyboard: KeyDown
      - name: Arrow left
        source_event:
          gamepad:
            button: DPadLeft
        target_events:
          - keyboard: KeyLeft
      - name: Arrow right
        source_event:
          gamepad:
            button: DPadRight
        target_events:
          - keyboard: KeyRight

      # Left stick: scrolling
      - name: Scroll up
        source_event:
          gamepad:
            axis:
              name: LeftStick
              direction: up
              deadzone: 0.2
        target_events:
          - mouse:
              button: WheelUp
      - name: Scroll down
        source_event:
          gamepad:
            axis:
              name: LeftStick
              direction: down
              deadzone: 0.2
        target_events:
          - mouse:
              button: WheelDown
      - name: Scroll left
        source_event:
          gamepad:
            axis:
              name: LeftStick
              direction: left
              deadzone: 0.2
        target_events:
          - mouse:
              button: WheelLeft
      - name: Scroll right
        source_event:
          gamepad:
            axis:
              name: LeftStick
              direction: right
              deadzone: 0.2
        target_events:
          - mouse:
              button: WheelRight

      # Right stick: pointer
      - name: Mouse pointer
        source_event:
          gamepad:
            axis:
              name: RightStick
        target_events:
          - mouse:
              motion:
                speed_pps: 800

      # Face buttons and triggers: mouse buttons
      - name: A left click
        source_event:
          gamepad:
            button: South
        target_events:
          - mouse:
              button: Left
      - name: X right click
        source_event:
          gamepad:
            button: West
        target_events:
          - mouse:
              button: Right
      - name: Y middle click
        source_event:
          gamepad:
            button: North
        target_events:
          - mouse:
              button: Middle
      - name: LT left click
        source_event:
          gamepad:
            trigger:
              name: LeftTrigger
              deadzone: 0.2
        target_events:
          - mouse:
              button: Left
      - name: RT right click
        source_event:
          gamepad:
            trigger:
              name: RightTrigger
              deadzone: 0.2
        target_events:
          - mouse:
              button: Right

      # Keyboard and Niri shortcuts
      - name: B escape
        source_event:
          gamepad:
            button: East
        target_events:
          - keyboard: KeyEsc
      - name: Menu return
        source_event:
          gamepad:
            button: Start
        target_events:
          - keyboard: KeyEnter
      - name: View launcher
        source_event:
          gamepad:
            button: Select
        target_events:
          - keyboard: KeyLeftMeta
          - keyboard: KeySpace
      - name: L3 close window
        source_event:
          gamepad:
            button: LeftStick
        target_events:
          - keyboard: KeyLeftMeta
          - keyboard: KeyQ
      - name: R3 maximize window
        source_event:
          gamepad:
            button: RightStick
        target_events:
          - keyboard: KeyLeftMeta
          - keyboard: KeyM
      - name: M1 session menu
        source_event:
          gamepad:
            button: RightPaddle1
        target_events:
          - keyboard: KeyLeftMeta
          - keyboard: KeyEsc
      - name: M2 play pause
        source_event:
          gamepad:
            button: LeftPaddle1
        target_events:
          - keyboard: KeyPlayPause
  '';
}
