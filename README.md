# E2E Scoreboard for SPI & APB Verification IP

📊 Developed E2E Scoreboard for SPI & APB Verification IP | SystemVerilog



Engineered a dynamic end-to-end scoreboard to verify packet transactions between SPI and APB interfaces through an AES crypto core. The setup involved multiple verification components including a BFM, network engine, and memory controller, all connected to class-based packet generators.

## 🔍 Key Highlights:
- Designed a configurable class-based packet generator supporting 3 traffic patterns:
  1. **All Same** – identical addresses with varied data across instances
  2. **Two Same** – 2 common addresses, rest unique
  3. **All Different** – fully distinct address-data pairs across instances
- Built an associative memory table (as shown 👇) to visualize and track data transactions per address across instances.
- Integrated test control via `.do` file to pass packet count (n) and added partial automation with a `.sh` script for batch runs.
- **Tools used:** QuestaSim, Cygwin, GVim

---

This project pushed my understanding of testbench design, automation, and cross-instance data correlation. Excited to scale this further and apply similar techniques to complex IPs. 🧠⚙️
