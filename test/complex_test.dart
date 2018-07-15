import 'package:test/test.dart';
import 'package:my_complex/my_complex.dart' show Complex;
import 'dart:math' as math;

List<Complex> listComplexCartesian = new List<Complex>();
List<Complex> listComplexPolar;
List<Complex> newListComplexCartesian;
List<Complex> listComplex=new List<Complex>();

final int LENGTH=5000;
final int NUMLOOPS = 1;
math.Random random;

void main() {
  random = new math.Random(new DateTime.now().millisecondsSinceEpoch);
  for (int i=0; i<LENGTH; i++)
    listComplexCartesian.add(new Complex.cartesian((random.nextDouble()-0.5)*1000, (random.nextDouble()-0.5)*1000));
  listComplexPolar = listComplexCartesian.map((Complex cc)=>new Complex.polar(cc.modulus, cc.argument)).toList();
  newListComplexCartesian = listComplexPolar.map((Complex cp)=>new Complex.cartesian(cp.real, cp.imaginary)).toList();
  listComplex..addAll(listComplexCartesian)..addAll(listComplexPolar);

  test("transformation between cartesian and polar works", () {
    for (int i = 0; i < LENGTH; i++) {
      var cp = listComplexPolar[i];
      var cc = listComplexCartesian[i];
      expect(cp.similar(cc), equals(true),
          reason: "$i: ${cp} not equal to ${cc}");
      expect(cc.similar(cp), equals(true),
          reason: "$i: ${cc} not equal to ${cp}");
    }
    for (int i=0; i<LENGTH-1; i++) {
      var cp = listComplexPolar[i];
      var cc = listComplexCartesian[i+1];
      expect(cc.similar(cp), equals(false));
    }
  });
  test("transformation between polar and cartesian works", () {
    for (int i=0; i<LENGTH; i++) {
      expect(listComplexPolar[i].similar(newListComplexCartesian[i]), equals(true));
    }

  });

  test("round trip works", () {
    for (int i=0; i<LENGTH; i++) {
      expect(listComplexCartesian[i].similar(newListComplexCartesian[i]), equals(true));
    }
  });

  test("addition works", () {
    for (int i=0; i<LENGTH-1; i++) {
      var cp1 = listComplexPolar[i];
      var cp2 = listComplexPolar[i+1];
      var cc1 = listComplexCartesian[i];
      var cc2 = listComplexCartesian[i+1];
      expect((cc1+cc2).similar(cp1+cp2), equals(true),
          reason:"$cc1 + $cc2 not equal to $cp1 + $cp2");
      expect((cp1+cc2).similar(cc1+cp2), equals(true),
          reason:"$cp1 + $cc2 not equal to $cc1 + $cp2");
      expect((cc1+cc1).similar(cp1+cp1), equals(true),
          reason:"$cc1 + $cc1 not equal to $cp1 + $cp1");

      expect((cc1+cc2).similar(cp1+cp1), equals(false),
          reason:"$cc1 + $cc2 equal to $cp1 + $cp1");
      expect((cp1+cc2).similar(cc1+cc1), equals(false),
          reason:"$cp1 + $cc2 equal to $cc1 + $cc1");
      expect((cc1+cc1).similar(cp1+cp2), equals(false),
          reason:"$cc1 + $cc1 equal to $cp1 + $cp2");
      expect((cc2+cc2).similar(cp1+cp2), equals(false),
          reason:"$cc2 + $cc2 equal to $cp1 + $cp2");

    }
  });
  test("subtraction works", () {
    for (int i=0; i<LENGTH-1; i++) {
      var cp1 = listComplexPolar[i];
      var cp2 = listComplexPolar[i+1];
      var cc1 = listComplexCartesian[i];
      var cc2 = listComplexCartesian[i+1];
      expect((cc1-cc2).similar(cp1-cp2), equals(true),
          reason:"($cc1) - ($cc2) = (${cc1-cc2}) not equal to \n($cp1) - ($cp2) = (${cp1-cp2})");
      expect((cp1-cc2).similar(cc1-cp2), equals(true),
          reason:"($cp1) - ($cc2) = (${cp1-cc2}) not equal to \n($cc1) - ($cp2) = (${cc1-cp2})");
      expect((cc1-cc1).similar(cp1-cp1), equals(true),
          reason:"($cc1) - ($cc1) = (${cc1-cc1}) not equal to \n($cp1) - ($cp1) = (${cp1 - cp1})");

      expect((cc1-cc2).similar(cp1-cp1), equals(false),
          reason:"$cc1 - $cc2 equal to $cp1 - $cp1");
      expect((cp1-cc2).similar(cc1-cc1), equals(false),
          reason:"$cp1 - $cc2 equal to $cc1 - $cc1");
      expect((cc1-cc1).similar(cp1-cp2), equals(false),
          reason:"$cc1 - $cc1 equal to $cp1 - $cp2");
      expect((cc2-cc2).similar(cp1-cp2), equals(false),
          reason:"$cc2 - $cc2 equal to $cp1 - $cp2");

    }
  });
  test("multiplication works", () {
    for (int i=0; i<LENGTH-1; i++) {
      var cp1 = listComplexPolar[i];
      var cp2 = listComplexPolar[i+1];
      var cc1 = listComplexCartesian[i];
      var cc2 = listComplexCartesian[i+1];
      expect((cc1*cc2).similar(cp1*cp2), equals(true),
          reason:"$cc1 * $cc2 (${cc1 * cc2}) should equal $cp1 * $cp2 (${cp1 * cp2})");
      expect((cp1*cc2).similar(cc1*cp2), equals(true));
      expect((cc1*cc1).similar(cp1*cp1), equals(true));
      expect((cc2*cc2).similar(cp2*cp2), equals(true));

      expect((cc1*cc2).similar(cp1*cp1), equals(false));
      expect((cp1*cc2).similar(cc1*cc1), equals(false));
      expect((cc1*cc1).similar(cp1*cp2), equals(false));
      expect((cc2*cc2).similar(cp1*cp2), equals(false));

    }
  });
  test("division works", () {
    for (int i=0; i<LENGTH-1; i++) {
      var cp1 = listComplexPolar[i];
      var cp2 = listComplexPolar[i+1];
      var cc1 = listComplexCartesian[i];
      var cc2 = listComplexCartesian[i+1];
      expect((cc1/cc2).similar(cp1/cp2), equals(true));
      expect((cp1/cc2).similar(cc1/cp2), equals(true));
      expect((cc1/cc1).similar(cp1/cp1), equals(true));
      expect((cc2/cc2).similar(cp2/cp2), equals(true));

      expect((cc1/cc2).similar(cp1/cp1), equals(false));
      expect((cp1/cc2).similar(cc1/cc1), equals(false));
      expect((cc1/cc1).similar(cp1/cp2), equals(false));
      expect((cc2/cc2).similar(cp1/cp2), equals(false));

    }
  });

  test("power works", () {
    for (int i=0; i<LENGTH; i++) {
      var cc = listComplexCartesian[i];
      var cp = listComplexPolar[i];
      var pow = (random.nextDouble()-0.5)*1000;
      expect(cc.pow(pow).similar(cp.pow(pow)), equals(true));
    }
  });

  test("turn works", () {
    for (int i=0; i<LENGTH; i++) {
      var cc = listComplexCartesian[i];
      var cp = listComplexPolar[i];
      var angle = (random.nextDouble()-0.5)*1000;
      expect(cc.turn(angle).similar(cp.turn(angle)), equals(true));
    }
  });

  test("inverse cartesian timed", () {
    var s = new Stopwatch();
    s.start();
    var total = Complex.ZERO;
    for (int j=0; j<NUMLOOPS; j++) {
      for (int i=0; i<LENGTH; i++) {
        total=(total +listComplexCartesian[i]).inverse;
        total= (total * listComplexCartesian[i]).inverse;
      }
    }
    s.stop();
  });
  test("inverse polar timed", () {
    var s = new Stopwatch();
    s.start();
    var total = Complex.ZERO;
    for (int j=0; j<NUMLOOPS; j++) {
      for (int i=0; i<LENGTH; i++) {
        total=(total +listComplexPolar[i]).inverse;
        total= (total * listComplexPolar[i]).inverse;
      }
    }
    s.stop();
  });

  test("my_complex constants", () {
    var c = new Complex.cartesian(0,1);
    expect(c.similar(Complex.ONE * Complex.I), equals(true),
        reason: "$c equals ${Complex.ONE} * ${Complex.I}");
    c = new Complex.cartesian(5,4);
    var ct = c.clone();
    var ct2 = c.clone();
    for (int i=0; i<4; i++) {
      ct = c.turn(math.PI/2);
      ct2 = c * Complex.I;
      expect(ct.similar(ct2), equals(true));
    }
    Complex a1;
    Complex a2;
    listComplex.forEach((Complex c) {
      [Complex.ONE, Complex.I, Complex.MINUSI, Complex.MINUSONE].forEach((
          Complex c2) {
        a1 = c + c2;
        a2 = c2 + c;
        expect(a1.similar(a2), equals(true),
            reason: "+ $a1 = $a2");
        a1 = c - c2;
        a2 = c2 - c;
        expect(a1.similar(-a2), equals(true),
            reason: "- $a1 = - $a2");
        a1 = c * c2;
        a2 = c2 * c;
        expect(a1.similar(a2), equals(true),
            reason: "* ($c, $c2) $a1 = $a2");
        a1 = c / c2;
        a2 = c2 / c;
        expect(a1.similar(a2.inverse), equals(true),
            reason: "/ $a1 = 1/$a2");
      });
    });
  });
}

