$fn = $preview ? 32 : 64;
EPS = 0.01;

// Torch dimensions
TORCH_RADIUS = 23;
THREAD_PITCH = 1;
THREAD_MAJOR_RADIUS = 21.4;
THREAD_MINOR_RADIUS = 21;
THREAD_LENGTH = 6; // Without glass, maybe 4.5 with glass

// Design parameters
LANTERN_RADIUS = 50;
WALL_THICKNESS = 2;
FLANGE_LENGTH = 2;

function inv_pythag(hypotenuse, other_leg) = sqrt(pow(hypotenuse, 2) - pow(other_leg, 2));

chord_offset = inv_pythag(LANTERN_RADIUS, TORCH_RADIUS);

module thread(minor, major, pitch, length) {
    linear_extrude(height=length, twist=360 * (length / pitch))
        translate([(major - minor) / 2, 0, 0])
            circle(r=(major + minor) / 2);
}

difference() {
    union() {
        difference() {
            sphere(r=LANTERN_RADIUS);
            translate([0, 0, chord_offset]) cylinder(r=LANTERN_RADIUS, h=LANTERN_RADIUS);
        }
        cylinder(r=TORCH_RADIUS, h=chord_offset + FLANGE_LENGTH);
        translate([0, 0, chord_offset + FLANGE_LENGTH - EPS]) thread(THREAD_MINOR_RADIUS, THREAD_MAJOR_RADIUS, THREAD_PITCH, THREAD_LENGTH + EPS);
    }
    union() {
        difference() {
            sphere(r=LANTERN_RADIUS - WALL_THICKNESS);
            translate([0, 0, inv_pythag(LANTERN_RADIUS - WALL_THICKNESS, TORCH_RADIUS - WALL_THICKNESS) + EPS]) cylinder(r=LANTERN_RADIUS, h=LANTERN_RADIUS);
        }
        cylinder(r=THREAD_MINOR_RADIUS - WALL_THICKNESS, h=chord_offset + FLANGE_LENGTH + THREAD_LENGTH + EPS);
    }
}
