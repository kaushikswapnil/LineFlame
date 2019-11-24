class Layer
{
 class Line
 {
   class Particle
   {
      PVector m_Position;
      PVector m_Acceleration, m_Velocity;
      
      Particle(PVector position)
      {
       m_Position = position.get();
       m_Acceleration = new PVector();
       m_Velocity = new PVector();
      }
      
      void Display()
      {
        ellipse(m_Position.x, m_Position.y, 4, 4);
      }
      
      void Update()
      {
        //AddGravity();
        AddMagForce();
        AddCapsuleDistanceForce();
        
        PhysicsStep();        
      }
      
      void PhysicsStep()
      {
        m_Velocity.add(m_Acceleration);
        m_Position.add(m_Velocity);
        
        m_Acceleration.mult(0.0f);
      }
      
      void AddAcceleration(PVector acc)
      {
        m_Acceleration.add(acc);
      }
      
      void AddGravity()
      {
        AddAcceleration(g_Gravity);
      }
      
      void AddMagForce()
      {
        PVector diameterPoint = new PVector(m_Position.x, g_CeilingDomeCenter.y);
        
        float distToDiameterPoint = diameterPoint.dist(m_Position);
        if (distToDiameterPoint < 10 || diameterPoint.y > m_Position.y)
        {
           distToDiameterPoint = 10.0f;
        }
        
        PVector magForce = PVector.mult(g_LineDir, g_PointMagFactor/distToDiameterPoint);
        
        if (diameterPoint.y > m_Position.y)
        {
           magForce.mult(-1.0f); 
        }
        
        AddAcceleration(magForce);
      }
      
      void AddCapsuleDistanceForce()
      {
         if (m_Position.y <= g_CeilingDomeCenter.y)
         {
          float distToCapsulePoint = m_Position.dist(g_CeilingDomeCenter);
          if (distToCapsulePoint >= g_FlameRadii)
          {
             PVector relDir = PVector.sub(m_Position, g_CeilingDomeCenter);
             relDir.normalize();
             
             float velInDirMag = PVector.dot(m_Velocity, relDir);
             if (velInDirMag >= 0.0f)
             {
                PVector constraintVelocityForce = PVector.mult(relDir, -velInDirMag);
                AddAcceleration(constraintVelocityForce);
             }
             
             float forceInDirMag = PVector.dot(m_Acceleration, relDir);
             if (forceInDirMag >= 0.0f)
             {
                PVector constraintForceForce = PVector.mult(relDir, -forceInDirMag);
                AddAcceleration(constraintForceForce);
             }
          }
         }
      }
   }
   
   PVector m_StartPos;
   float m_Phase;   
   float m_MinLength, m_MaxLength;
   boolean m_Growing;
   
   Particle m_Particle;
      
   Line(PVector startPos, float initPhase, float minLength, float maxLength)
   {
      m_StartPos = startPos.get();
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
      
      PVector partPos = PVector.add(m_StartPos, PVector.mult(g_LineDir, GetLineLength() + 20.0f));
      m_Particle = new Particle(partPos);
   }
   
   void Update()
   {
      PVector endPoint = GetLineEndPoint();
      PVector partPos = m_Particle.m_Position;
      
      float dist = partPos.dist(endPoint);
      float idealDist = 20.0f;
      
      float distDiff = dist - idealDist;
      
      PVector acc = PVector.mult(g_LineDir, -distDiff*g_PointLineSpringFactor);
      m_Particle.AddAcceleration(acc);
      
      m_Particle.Update();
   }
   
   void Display()
   {
      PVector endPos = GetLineEndPoint();
      line(m_StartPos.x ,m_StartPos.y, endPos.x, endPos.y);
      
      m_Particle.Display();      
   }
   
   float GetLineLength()
   {
     float lineLength = map(m_Phase, 0.0f, 1.0f, m_MinLength, m_MaxLength);
     return lineLength;
   }
   
   PVector GetLineEndPoint()
   {
     PVector endPos = PVector.add(m_StartPos, PVector.mult(g_LineDir, GetLineLength()));
     return endPos;
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
   m_Color = layerCol.get();
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
     line.Update();
   }
 }
}
