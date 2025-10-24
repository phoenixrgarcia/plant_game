// ...existing code...
final Map<String, List<List<int>>> PlantAoeMap = {
  'none': const <List<int>>[],
  // cardinal (N, E, S, W)
  'cardinal': const <List<int>>[
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
  ],
  // diagonal neighbours (NE, SE, NW, SW)
  'diagonal': const <List<int>>[
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1],
  ],
  // full 3x3 around (8 neighbours)
  'square': const <List<int>>[
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0],
    [-1, 1],
  ],
  'up2': const <List<int>>[
    [0, 1],
    [0, 2],
  ],
  // alias keys for convenience
  'cross': const <List<int>>[
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
  ],
  'adjacent': const <List<int>>[
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [1, 1],
    [1, -1],
    [-1, 1],
    [-1, -1],
  ],
};
