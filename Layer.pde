class Layer
{
 class Line
 {
   PVector m_StartPos;
   float m_Phase;   
   float m_MinLength, m_MaxLength;
   boolean m_Growing;
      
   Line(PVector startPos, float initPhase, float minLength, float maxLength)
   {
      m_StartPos = startPos.copy();
      m_Phase = initPhase;
      m_MinLength = minLength;
      m_MaxLength = maxLength;
      
      if (random(1.0f) < 0.5f)
      {
        m_Growing = true;
      }
      else
      {
        m_Growing = false;
      }
   }
   
   void Display()
   {
      float lineLength = map(m_Phase, 0.0f, 1.0f, m_MinLength, m_MaxLength);
      PVector endPos = PVector.add(m_StartPos, PVector.mult(g_LineDir, lineLength));
      line(m_StartPos.x ,m_StartPos.y, endPos.x, endPos.y);
      
      float pointDist = lineLength + 20.0f;
      PVector pointPos = PVector.add(m_StartPos, PVector.mult(g_LineDir, pointDist));
      ellipse(pointPos.x, pointPos.y, 4, 4);
   }
   
   void GrowPhase(float phaseChange)
   {
     float phase = m_Phase;
     if (phase >= 1.0f)
     {
       m_Growing = false; 
     }
     else if (phase <= 0.0f)
     {
       m_Growing = true;
     }
     
     if (m_Growing)
     {
       phase += phaseChange;
     }
     else
     {
       phase -= phaseChange;
     }
     
     m_Phase = min(max(phase, 0.0f), 1.0f);
   }
 }
  
 ArrayList<Line> m_Lines;
 PVector m_Color;
 float m_Alpha;
 
 float m_MaxLineHeight;
 float m_MinLineHeight;
 int m_CycleLength;
 int m_LineCount;
 
 Layer(PVector layerCol, int lineCount, float minLineLength, float maxLineLength, float alpha, int cycleLength)
 {
   m_Color = layerCol.copy();
   m_MinLineHeight = minLineLength;
   m_MaxLineHeight = maxLineLength;
   m_Alpha = alpha;
   m_CycleLength = cycleLength;
   m_LineCount = lineCount;
   
   GenerateLines();
 }
 
 void GenerateLines()
 {
   m_Lines = new ArrayList<Line>();
   
   float theta = 0.0f;
   float angIncrement = PI/m_LineCount;
   
   while(theta <= PI)
   {
      PVector relPos = PVector.fromAngle(theta);
      relPos.mult(g_FlameRadii);
      
      PVector startPos = PVector.add(relPos, g_Center);
      
      float projectionTheta;
      if (theta >= PI/2)
      {
         projectionTheta = PI - theta;
      }
      else
      {
         projectionTheta = theta;
      }
      
      float heightProjectedOnFlameDir = g_FlameRadii * sin(projectionTheta);
      
      float minLength = m_MinLineHeight;// + heightProjectedOnFlameDir;
      float maxLength = m_MaxLineHeight;// + heightProjectedOnFlameDir;
      
      m_Lines.add(new Line(startPos, random(0.0f, 1.0f), minLength, maxLength));
      
      theta += angIncrement;
   }
 }
 
 void Display()
 {
    stroke(m_Color.x, m_Color.y, m_Color.z, m_Alpha);
    
    for (Line line : m_Lines)
    {
       line.Display(); 
    }
 }
 
 void Update()
 {
   float phaseChange = 1.0f/m_CycleLength;
   for (Line line : m_Lines)
   {
     line.GrowPhase(phaseChange);
   }
 }
}
