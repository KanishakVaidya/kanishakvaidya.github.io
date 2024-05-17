import matplotlib.pyplot as plt
import numpy as np

t = np.linspace(-10, 10, 1000)
sig = 1 / (1 + np.exp(-t))
relu = [max(0, tt) for tt in t]

plt.minorticks_on()
plt.grid(which='major', color='#c0c0c0', linestyle="-")
plt.grid(which='minor', color='#d4d4d4', linestyle="--")
plt.axhline(color="#1e1e1e")
plt.axhline(y=1.0, color="#1e1e1e", linestyle="--")
plt.axvline(color="#1e1e1e")
plt.plot(t, sig, linewidth=2, label=r"$\sigma(z) = \frac{1}{1 + e^{-z}}$")
plt.plot(t, relu,linewidth=2, label=r"ReLU(z)")
plt.xlim(-5, 5)
plt.ylim(-0.5, 5)
plt.xlabel("z")
plt.legend(fontsize=14)
plt.tight_layout()
# plt.show()
plt.savefig('sigmoid.svg', transparent=True)
