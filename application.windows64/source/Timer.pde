public static boolean stopTimers = false;
class Timer
{
  float start = 0;
  void getTime()
  {
    start = millis();
  }

  boolean wait(float time)
  {
    if (start+time<=millis())
    {
      return true;
    } else
      return false;
  }
}