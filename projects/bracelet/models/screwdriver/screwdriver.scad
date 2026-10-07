// screwdriver — a kid's hex key for the cone pin (models/cone-pin).
//
// The cone pin's foot has a hex socket (lib/charm-cone.scad: `cn_key`). This
// is the key that fits it, on a big flat paddle a small hand can pinch and
// twist like a door key. Push the bit into the pin's foot from under the
// band, hold the paddle still, and screw the charm on or off above.
//
// PRINT IT LYING FLAT, on the paddle's underside, exactly as this file lays
// it out. The bit lies on one of its flats, so its layers run ALONG it and a
// twist shears the layers lengthways, not apart. No support, no brim.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

// ------------------------------------------------------------------- bit
key_fit   = 0.05;   // the bit is this much under `cn_key` a side, on top of
                    //   the socket's own `cn_key_fit`: a printed key prints
                    //   a little fat sideways, where a steel one doesn't
key_len   = 4.0;    // the straight hex: the socket's depth + the foot's
                    //   recess (2.9 mm), plus a millimetre to spare
key_ch    = 0.3;    // the tip's chamfer, to find the socket's lead-in

// ----------------------------------------------------------------- shaft
shaft_r   = 4.0;    // the round shaft, cut flat where it meets the bed
shaft_len = 16;     // from the paddle to the start of the taper
taper_len = 5;      // shaft down to the bit

// ---------------------------------------------------------------- paddle
paddle_d  = 32;     // the round back of the paddle
paddle_nd = 14;     // where it narrows into the shaft
paddle_len = 40;    // centre of the back to the front edge
paddle_t  = 8;      // its thickness
paddle_ch = 1.5;    // the top edge's chamfer, for small fingers
foot_ch   = 0.4;    // the bottom edge's chamfer, for the elephant's foot
loop_d    = 6;      // a hole for a string, so it stays with the bracelet
loop_wall = 4;      // paddle left behind the hole

// --------------------------------------------------------------- derived
key_af = cn_key - 2*key_fit;                  // 2.80 across flats
key_z  = key_af / 2;                          // the tool's axis: the bit
                                              //   lies on a flat at z = 0
neck_x = paddle_len - paddle_d/2;             // paddle's front edge
bit_x  = neck_x + shaft_len + taper_len;      // where the straight hex starts
tip_x  = bit_x + key_len;                     // overall length

assert(key_af < cn_key_af, "the bit is no smaller than the socket");
assert(key_len > cn_key_d + cn_recess, "the bit can't reach the socket's end");
assert(shaft_r > key_z, "the shaft must reach down to the bed");
assert(paddle_t > 2*shaft_r - key_z - 1, "the shaft stands above the paddle");

echo(str("screwdriver: ", tip_x + paddle_d/2, " mm long, a ", key_af,
         " mm hex bit (socket ", cn_key_af, ", ", (cn_key_af - key_af)/2,
         " a side), ", key_len, " long"));

// A hex prism along +x, lying on a flat at z = 0 from x = 0 to `len`.
module hex_x(af, len)
    translate([0, 0, key_z]) rotate([0, 90, 0])
        linear_extrude(len)
            polygon([for (k = [0 : 5]) (af / sqrt(3)) *
                     [cos(30 + 60*k), sin(30 + 60*k)]]);

// A thin slice of the shaft at x: round, with its underside cut flat on the
// bed (the circle's flank meets the bed 21 deg off vertical).
module shaft_slice(x)
    translate([x, 0, 0]) intersection() {
        translate([0, 0, key_z]) rotate([0, 90, 0])
            cylinder(r = shaft_r, h = 0.01);
        translate([-1, -shaft_r, 0]) cube([2, 2*shaft_r, 2*shaft_r]);
    }

// The paddle's outline: a round back narrowing to the shaft.
module paddle_outline(d = 0)
    offset(delta = d) hull() {
        circle(d = paddle_d);
        translate([neck_x - paddle_nd/2, 0]) circle(d = paddle_nd);
    }

module paddle() difference() {
    hull() {
        linear_extrude(0.01) paddle_outline(-foot_ch);
        translate([0, 0, foot_ch])
            linear_extrude(paddle_t - foot_ch - paddle_ch)
                paddle_outline();
        translate([0, 0, paddle_t - 0.01])
            linear_extrude(0.01) paddle_outline(-paddle_ch);
    }
    translate([-paddle_d/2 + loop_wall + loop_d/2, 0, -1])
        cylinder(d = loop_d, h = paddle_t + 2);
}

module screwdriver() {
    paddle();
    // the shaft, from inside the paddle out to the taper
    hull() {
        shaft_slice(neck_x - paddle_nd/2);
        shaft_slice(neck_x + shaft_len);
    }
    // the taper, from the shaft down onto the bit
    hull() {
        shaft_slice(neck_x + shaft_len);
        translate([bit_x - 0.01, 0, 0]) hex_x(key_af, 0.02);
    }
    // the bit, with a chamfered tip
    translate([bit_x, 0, 0]) hex_x(key_af, key_len - key_ch);
    hull() {
        translate([tip_x - key_ch - 0.01, 0, 0]) hex_x(key_af, 0.01);
        translate([tip_x - 0.01, 0, key_ch]) hex_x(key_af - 2*key_ch, 0.01);
    }
}

screwdriver();
