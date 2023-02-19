# Bad Boids -- Named in honour of the classic teaching example.

## A little flocking demo to play with defining simple 3d models, and drawing them.
* Hit the settings icom to control folocking parameters # boids, zoom and camera controls.

Demo: https://j6c-001.github.io/badboids

![Screenshot](bb1.png)

Model definition looks like this:
```
class Wedge extends Model {
  List getModel() {
    return makeModel([
      [
        Colors.red,
        [
          [-2, 0, 0],
          [2, 0, 0],
          [0, 2, 0]
        ]
      ],
      [
        Colors.green,
        [
          [-2, 0, 0],
          [2, 0, 0],
          [1, 1, -6]
        ]
      ],
      [
        Colors.amber,
        [
          [-2, 0, 0],
          [0, 2, 0],
          [1, 1, -6]
        ]
      ],
      [
        Colors.blue,
        [
          [2, 0, 0],
          [0, 2, 0],
          [1, 1, -6]
        ]
      ]
    ], false);
  }
}
```
