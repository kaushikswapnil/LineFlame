PVector g_LineDir = new PVector(0, -1);
PVector g_Center;
float g_FlameRadii = 100.0f;

ArrayList<Layer> g_FlameLayers;

void setup()
{
  size(800, 800);
  
  g_Center = new PVector(width/2, (height/2) + 150.0f);
  
  g_FlameLayers = new ArrayList<Layer>();
  
  g_FlameLayers.add(new Layer(new PVector(180, 180, 180), 100, 100.0f, 500.0f, 100, 300));
  g_FlameLayers.add(new Layer(new PVector(200, 200, 200), 150, 100.0f, 450.0f, 125, 300));
  g_FlameLayers.add(new Layer(new PVector(230, 230, 230), 200, 100.0f, 400.0f, 150, 300));
  g_FlameLayers.add(new Layer(new PVector(222, 134, 0), 250, 100.0f, 375.0f, 180, 310));
  g_FlameLayers.add(new Layer(new PVector(255, 255, 0), 300, 100.0f, 300.0f, 180, 300));
  g_FlameLayers.add(new Layer(new PVector(255, 103, 0), 350, 100.0f, 255.0f, 200, 320));
  g_FlameLayers.add(new Layer(new PVector(255, 0, 0), 400, 100.0f, 180.0f, 220, 350));
}

void draw()
{
  background(44, 0, 0);
  strokeWeight(3.f);
  
  for (Layer layer : g_FlameLayers)
  {
   layer.Update();
   layer.Display();
  }
}