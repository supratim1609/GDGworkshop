import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

/// =========================================================================
/// 🛠️ PROJECT: ARCHITEKT v2.5 [THE ULTIMATE WORKSHOP]
/// 
/// A dedicated environment for visualizing Flutter's Rendering Pipeline, 
/// the Three Tree architecture, and Flex layout negotiation.
/// =========================================================================

class ArchitektLab extends StatefulWidget {
  const ArchitektLab({super.key});

  @override
  State<ArchitektLab> createState() => _ArchitektLabState();
}

class _ArchitektLabState extends State<ArchitektLab> with TickerProviderStateMixin {
  // --- 🪐 ENGINE SIMULATION STATE ---
  double _stressLevel = 0.0;
  bool _isExploded = false;
  int _activePhase = 0; // 0: Idle, 1: Layout, 2: Paint, 3: Composite
  double _rotation = -0.4;
  bool _showRealWidgets = false;
  bool _isTight = false;
  
  // --- 🏗️ STUDENT WORKSHOP STATE ---
  double _userWidth = 260.0;
  double _userHeight = 360.0;
  double _userBorderRadius = 24.0;
  double _userElevation = 0.0;
  double _userPadding = 20.0;
  Color _userColor = Colors.blueAccent;
  String _userLabel = "ARCHITEKT";
  
  // --- 🧪 LAYOUT PROPERTIES ---
  bool _isColumn = true;
  MainAxisAlignment _mainAxis = MainAxisAlignment.center;
  CrossAxisAlignment _crossAxis = CrossAxisAlignment.center;

  // --- 📊 METRICS & SESSION ---
  int _stateCounter = 0;
  int _rebuildCount = 0;
  int _hitCount = 0;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2)
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 1000;

    // Simulate CPU Stress if active
    if (_stressLevel > 0.1) {
      for(int i=0; i < (_stressLevel * 8000000).toInt(); i++) { math.sqrt(i); }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF030307),
      body: Stack(
        children: [
          _buildBackgroundGrid(),
          _buildLiveStage(isSmallScreen),
          if (size.width > 600) _buildLeftDiagnosticsHUD(isSmallScreen),
          if (size.width > 700) _buildRightControlDeck(isSmallScreen),
          _buildBottomPipelineHUD(isSmallScreen),
        ],
      ),
    );
  }

  // --- 🏗️ MAIN STAGE ---
  Widget _buildLiveStage(bool isSmall) {
    return Center(
      child: GestureDetector(
        onPanUpdate: (details) => setState(() => _rotation += details.delta.dx * 0.01),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = isSmall ? 0.7 : 1.0;
            final tilt = _isExploded ? 0.6 : 0.0;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..scale(scale)
                ..rotateY(_rotation)
                ..rotateX(tilt),
              child: SizedBox(
                width: 300,
                height: 400,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    if (_isExploded) Positioned.fill(child: _buildConnectorLines()),
                    if (_isExploded) _buildBackLayers(),

                    if (_activePhase >= 2) _buildPaintTraceVisualizer(),

                    _buildTheStudentWidget(),

                    if (_isExploded) _buildFrontLayers(),
                    if (_activePhase == 1) _buildLayoutConstraintVisualizer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 🛠️ COMPONENT: THE STUDENT WIDGET ---
  Widget _buildTheStudentWidget() {
    return ConstrainedBox(
      constraints: _isTight 
        ? const BoxConstraints.tightFor(width: 400, height: 500) 
        : const BoxConstraints(maxWidth: 400, maxHeight: 500),
      child: _StudentWidget(
        width: _userWidth,
        height: _userHeight,
        color: _userColor,
        radius: _userBorderRadius,
        elevation: _userElevation,
        label: _userLabel,
        counter: _stateCounter,
        padding: _userPadding,
        isColumn: _isColumn,
        showRealWidgets: _showRealWidgets,
        mainAxis: _mainAxis,
        crossAxis: _crossAxis,
        pulse: _pulseController.value,
        onTap: () => setState(() {
          _stateCounter++;
          _hitCount++;
        }),
      ),
    );
  }

  // --- 🎛️ HUD: LEFT DIAGNOSTICS ---
  Widget _buildLeftDiagnosticsHUD(bool isSmall) {
    return _HUDPanel(
      left: 20, width: isSmall ? 220 : 280,
      children: [
        const _HUDLabel(text: "// PERFORMANCE_METRICS", color: Colors.greenAccent),
        const SizedBox(height: 20),
        _StatField(label: "FRAME_RATE", value: "${(60 - (_stressLevel * 45)).toInt()} FPS", color: _stressLevel > 0.5 ? Colors.redAccent : Colors.greenAccent),
        _StatField(label: "BUILD_TIME", value: "${(1.0 + (_stressLevel * 15)).toStringAsFixed(1)} ms", color: _stressLevel > 0.5 ? Colors.redAccent : Colors.blueAccent),
        _StatField(label: "REBUILDS", value: "$_rebuildCount", color: Colors.orangeAccent),
        _StatField(label: "INTERACTIONS", value: "$_hitCount", color: Colors.pinkAccent),
        const SizedBox(height: 40),
        const _HUDLabel(text: "// ENGINE_ARCHITECTURE", color: Colors.white38),
        _SchemaTreeView(),
      ],
    );
  }

  // --- 🎛️ HUD: RIGHT CONTROL DECK ---
  Widget _buildRightControlDeck(bool isSmall) {
    return _HUDPanel(
      right: 20, width: isSmall ? 240 : 320,
      children: [
        const _HUDLabel(text: "// CODE_ALONG_SECTION", color: Colors.blueAccent),
        _InteractiveInput(
          label: "Widget.label", 
          child: TextField(
            onChanged: (v) => setState(() => _userLabel = v.toUpperCase()),
            style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
            decoration: const InputDecoration(hintText: "LABEL", border: InputBorder.none),
          )
        ),
        _InteractiveSlider(label: "BorderRadius", val: _userBorderRadius, max: 40, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => _userBorderRadius = v)),
        _InteractiveSlider(label: "Elevation", val: _userElevation, max: 50, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => _userElevation = v)),
        _InteractiveSlider(label: "Width", val: _userWidth, max: 400, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => _userWidth = v)),
        _InteractiveSlider(label: "Height", val: _userHeight, max: 500, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => _userHeight = v)),
        
        const SizedBox(height: 25),
        const _HUDLabel(text: "// BEGINNER_LAYOUT_LAB", color: Colors.greenAccent),
        _DeckToggle(label: _isColumn ? "AXIS: VERTICAL (COLUMN)" : "AXIS: HORIZONTAL (ROW)", active: true, onTap: () => setState(() => _isColumn = !_isColumn)),
        _DeckDropdown(label: "MainAxisAlignment", options: ["START", "CENTER", "END", "SPACE_BETWEEN"], onChanged: (v) {
          setState(() => _mainAxis = MainAxisAlignment.values[{"START":0,"CENTER":2,"END":1,"SPACE_BETWEEN":3}[v]!]);
        }),
        _InteractiveSlider(label: "Padding", val: _userPadding, max: 60, activeColor: Colors.greenAccent, onChanged: (v) => setState(() => _userPadding = v)),
        
        const SizedBox(height: 25),
        const _HUDLabel(text: "// WIDGET_CATALOG", color: Colors.pinkAccent),
        _DeckToggle(label: _showRealWidgets ? "MODE: COMPONENTS" : "MODE: GEOMETRY", active: _showRealWidgets, onTap: () => setState(() => _showRealWidgets = !_showRealWidgets)),
        
        const SizedBox(height: 25),
        const _HUDLabel(text: "// ENGINE_SIMULATION", color: Colors.orangeAccent),
        _DeckToggle(label: "X-RAY LAYOUT", active: _activePhase == 1, onTap: () => setState(() => _activePhase = _activePhase == 1 ? 0 : 1)),
        _DeckToggle(label: "PAINT TRACE", active: _activePhase == 2, onTap: () => setState(() => _activePhase = _activePhase == 2 ? 0 : 2)),
        _DeckToggle(label: "EXPLODE LAYERS", active: _isExploded, onTap: () => setState(() => _isExploded = !_isExploded)),
        
        const SizedBox(height: 10),
        const _HUDLabel(text: "// CONSTRAINTS", color: Colors.purpleAccent),
        _DeckToggle(label: _isTight ? "TIGHT (FORCED)" : "LOOSE (FLEXIBLE)", active: _isTight, onTap: () => setState(() => _isTight = !_isTight)),
        
        const SizedBox(height: 25),
        const _HUDLabel(text: "// ENGINE_STRESS_TEST", color: Colors.redAccent),
        Slider(value: _stressLevel, activeColor: Colors.redAccent, onChanged: (v) => setState(() => _stressLevel = v)),
      ],
    );
  }

  // --- 🔍 SUB-COMPONENTS: STAGE ELEMENTS ---
  Widget _buildConnectorLines() {
    return CustomPaint(painter: ConnectionPainter());
  }

  Widget _buildBackLayers() {
    return Stack(
      children: [
        _GhostLayer(x: -200, y: -150, z: -300, label: "WIDGET TREE", color: Colors.blueAccent, icon: Icons.auto_awesome_mosaic),
        _GhostLayer(x: -100, y: -75, z: -150, label: "ELEMENT TREE", color: Colors.greenAccent, icon: Icons.terminal),
      ],
    );
  }

  Widget _buildFrontLayers() {
    return Stack(
      children: [
        _GhostLayer(x: 100, y: 75, z: 150, label: "RENDER OBJECT", color: Colors.pinkAccent, icon: Icons.brush),
        _GhostLayer(x: 200, y: 150, z: 300, label: "GPU / LAYER", color: Colors.orangeAccent, icon: Icons.layers),
      ],
    );
  }

  Widget _buildLayoutConstraintVisualizer() {
    return CustomPaint(
      painter: ConstraintPainter(
        _isTight ? 400 : 400, _isTight ? 500 : 500, _userWidth, _userHeight
      )
    );
  }

  Widget _buildPaintTraceVisualizer() {
    return IgnorePointer(
      child: CustomPaint(
        size: const Size(300, 400),
        painter: PaintPathPainter(_pulseController.value, _userWidth, _userHeight),
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return Positioned.fill(child: CustomPaint(painter: GridPainter()));
  }

  Widget _buildBottomPipelineHUD(bool isSmall) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50, width: double.infinity, margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              children: [
                Container(width: 6, color: Colors.blueAccent),
                const SizedBox(width: 15),
                const Icon(Icons.webhook, color: Colors.blueAccent, size: 18),
                const SizedBox(width: 12),
                if (!isSmall) const Text("ENGINE_LIFECYCLE: ", style: TextStyle(color: Colors.white38, fontSize: 11)),
                Expanded(
                  child: Text(
                    _activePhase == 0 ? "IDLE" : ["LAYOUT_PHASE", "PAINT_PHASE", "COMPOSITION_PHASE"][_activePhase-1],
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Text("STABLE @ 60FPS", style: TextStyle(color: Colors.greenAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 🏗️ THE STUDENT WIDGET OBJECT ---
class _StudentWidget extends StatelessWidget {
  final Color color;
  final double radius, elevation, pulse, padding, width, height;
  final String label;
  final int counter;
  final bool isColumn, showRealWidgets;
  final MainAxisAlignment mainAxis;
  final CrossAxisAlignment crossAxis;
  final VoidCallback onTap;

  const _StudentWidget({
    required this.color, required this.radius, required this.elevation, required this.label,
    required this.counter, required this.padding, required this.width, required this.height,
    required this.isColumn, required this.showRealWidgets, required this.mainAxis, required this.crossAxis,
    required this.pulse, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, height: height, padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.1 + (pulse * 0.1)), blurRadius: 40 + elevation, spreadRadius: elevation / 2),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Flex(
                direction: isColumn ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: mainAxis,
                crossAxisAlignment: crossAxis,
                children: showRealWidgets ? _buildRealComponents() : _buildGeometryBlocks(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRealComponents() => [
    Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 3)),
    const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.rocket_launch, color: Colors.blueAccent, size: 45)),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.blueAccent)),
      child: const Text("EXECUTE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    ),
    if (counter > 0) _CounterOrb(val: counter),
  ];

  List<Widget> _buildGeometryBlocks() => [
    _BoxBlock(color: Colors.blueAccent, id: "W1"),
    _BoxBlock(color: Colors.greenAccent, id: "W2"),
    _BoxBlock(color: Colors.pinkAccent, id: "W3"),
    if (counter > 0) _CounterOrb(val: counter),
  ];
}

class _CounterOrb extends StatelessWidget {
  final int val;
  const _CounterOrb({required this.val});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 15),
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
    child: Text("$val", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

class _BoxBlock extends StatelessWidget {
  final Color color;
  final String id;
  const _BoxBlock({required this.color, required this.id});
  @override
  Widget build(BuildContext context) => Container(
    width: 55, height: 55, margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(color: color.withOpacity(0.1), border: Border.all(color: color, width: 2), borderRadius: BorderRadius.circular(12)),
    child: Center(child: Text(id, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold))),
  );
}

// --- 🖼️ UI HELPERS: THE HUD SYSTEM ---
class _HUDPanel extends StatelessWidget {
  final double? left, right;
  final double width;
  final List<Widget> children;
  const _HUDPanel({this.left, this.right, required this.width, required this.children});

  @override
  Widget build(BuildContext context) => Positioned(
    left: left, right: right, top: 40, bottom: 100,
    child: Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ),
      ),
    ),
  );
}

class _StatField extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatField({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white24, fontSize: 11)),
        Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      ],
    ),
  );
}

class _DeckToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _DeckToggle({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? Colors.blueAccent.withOpacity(0.2) : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? Colors.blueAccent : Colors.white.withOpacity(0.05)),
      ),
      child: Center(child: Text(label, style: TextStyle(color: active ? Colors.blueAccent : Colors.white38, fontSize: 11, fontWeight: FontWeight.bold))),
    ),
  );
}

class _DeckDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final Function(String) onChanged;
  const _DeckDropdown({required this.label, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6, runSpacing: 6,
        children: options.map((opt) => GestureDetector(
          onTap: () => onChanged(opt),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white.withOpacity(0.06)), borderRadius: BorderRadius.circular(6)),
            child: Text(opt, style: const TextStyle(color: Colors.white60, fontSize: 9)),
          ),
        )).toList(),
      ),
      const SizedBox(height: 18),
    ],
  );
}

class _InteractiveSlider extends StatelessWidget {
  final String label;
  final double val, max;
  final Color activeColor;
  final Function(double) onChanged;
  const _InteractiveSlider({required this.label, required this.val, required this.max, required this.activeColor, required this.onChanged});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
      Slider(value: val, max: max, activeColor: activeColor, onChanged: onChanged),
    ],
  );
}

class _HUDLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _HUDLabel({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
  );
}

class _InteractiveInput extends StatelessWidget {
  final String label;
  final Widget child;
  const _InteractiveInput({required this.label, required this.child});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10)),
      Container(
        height: 38, margin: const EdgeInsets.only(top: 6, bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
        child: child,
      ),
    ],
  );
}

class _SchemaTreeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _Node(text: "WIDGET", color: Colors.blueAccent, d: 0),
      _Node(text: "ELEMENT", color: Colors.greenAccent, d: 1),
      _Node(text: "RENDER_OBJ", color: Colors.pinkAccent, d: 2),
      _Node(text: "LAYER / GPU", color: Colors.orangeAccent, d: 3),
    ],
  );
}

class _Node extends StatelessWidget {
  final String text;
  final Color color;
  final int d;
  const _Node({required this.text, required this.color, required this.d});
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: d * 22.0, bottom: 10),
    child: Row(children: [Icon(Icons.subdirectory_arrow_right, color: color, size: 16), const SizedBox(width: 10), Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))]),
  );
}

// --- 🖌️ PAINTERS ---
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.blueAccent.withOpacity(0.04)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 60) canvas.drawLine(Offset(i, 0), Offset(i, size.height), p);
    for (double i = 0; i < size.height; i += 60) canvas.drawLine(Offset(0, i), Offset(size.width, i), p);
  }
  @override bool shouldRepaint(CustomPainter o) => false;
}

class ConstraintPainter extends CustomPainter {
  final double mW, mH, cW, cH;
  ConstraintPainter(this.mW, this.mH, this.cW, this.cH);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final p1 = Paint()..color = Colors.orangeAccent.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: mW + 40, height: mH + 40), p1);
    final p2 = Paint()..color = Colors.pinkAccent..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: cW, height: cH), p2);
  }
  @override bool shouldRepaint(CustomPainter o) => true;
}

class PaintPathPainter extends CustomPainter {
  final double a, w, h;
  PaintPathPainter(this.a, this.w, this.h);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final p = Paint()..color = Colors.pinkAccent..style = PaintingStyle.stroke..strokeWidth = 3;
    final r = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: w, height: h), const Radius.circular(24));
    final m = Path()..addRRect(r);
    final metric = m.computeMetrics().first;
    canvas.drawPath(metric.extractPath(0, metric.length * a), p);
  }
  @override bool shouldRepaint(CustomPainter o) => true;
}

class ConnectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    final p = Paint()..color = Colors.white.withOpacity(0.1)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    _l(canvas, const Offset(-200, -150), const Offset(200, 150), p);
    _l(canvas, const Offset(100, -150), const Offset(500, 150), p);
    _l(canvas, const Offset(-200, 250), const Offset(200, 550), p);
    _l(canvas, const Offset(100, 250), const Offset(500, 550), p);
  }
  void _l(Canvas c, Offset p1, Offset p2, Paint p) {
    c.drawLine(p1, p2, p);
    c.drawCircle(p1, 2, p..style = PaintingStyle.fill);
    c.drawCircle(p2, 2, p);
    p.style = PaintingStyle.stroke;
  }
  @override bool shouldRepaint(CustomPainter o) => false;
}

class _GhostLayer extends StatelessWidget {
  final double x, y, z;
  final String label;
  final Color color;
  final IconData icon;
  const _GhostLayer({required this.x, required this.y, required this.z, required this.label, required this.color, required this.icon});
  @override
  Widget build(BuildContext context) => Transform(
    transform: Matrix4.identity()..translate(x, y, z),
    child: Container(
      width: 300, height: 400,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.85), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withOpacity(0.8), width: 3), boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 40)]),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 70), const SizedBox(height: 25), Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 5))]),
      ),
    ),
  );
}
