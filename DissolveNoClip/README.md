# DissolveNoClip shader
#### An Unlit shader that implements a Dissolve effect using on transparency. It doesn't use clip/discard function.

On certain platforms, due to the GPU architecture, using clip/discard can affect performance. This was my attempt at implementing Dissolve using only transparency. The math behind it is not perfect, but it gives you a fairly decent result.
