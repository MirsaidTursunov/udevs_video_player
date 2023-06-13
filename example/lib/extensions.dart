extension Extensions on int {
  String toState() {
    int state = this;
    String sState = '';
    switch (state) {
      case 0:
        sState = 'STATE_QUEUED';
        break;
      case 1:
        sState = 'STATE_STOPPED';
        break;
      case 2:
        sState = 'STATE_DOWNLOADING';
        break;
      case 3:
        sState = 'STATE_COMPLETED';
        break;
      case 4:
        sState = 'STATE_FAILED';
        break;
      case 5:
        sState = 'STATE_REMOVING';
        break;
      case 7:
        sState = 'STATE_RESTARTING';
        break;
    }
    return sState;
  }
}
