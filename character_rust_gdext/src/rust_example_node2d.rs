use godot::prelude::*;
use godot::classes::Node2D;
use godot::classes::INode2D;

#[derive(GodotClass)]
#[class(base=Node2D)]
struct CharacterRust {
    #[export]
    speed: f64,
    #[export]
    angular_speed: f64,
    base: Base<Node2D>
}

#[godot_api]
impl INode2D for CharacterRust {
    fn init(base: Base<Node2D>) -> Self {
        godot_print!("Hello from Rust!");

        Self {
            speed: 400.0,
            angular_speed: std::f64::consts::PI,
            base,
        }
    }

    fn physics_process(&mut self, delta: f64) {
        // GDScript code:
        //
        // rotation += angular_speed * delta
        // var velocity = Vector2.UP.rotated(rotation) * speed
        // position += velocity * delta

        let radians = (self.angular_speed * delta) as f32;
        self.base_mut().rotate(radians);

        let rotation = self.base().get_rotation();
        let velocity = Vector2::UP.rotated(rotation) * self.speed as f32;
        self.base_mut().translate(velocity * delta as f32);

        // or verbose:
        // let this = self.base_mut();
        // this.set_position(
        //     this.position() + velocity * delta as f32
        // );
    }
}