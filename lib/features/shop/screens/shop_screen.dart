import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/hunter_model.dart'; // Import model InventoryItem
import '../../../../providers/system_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( // Controller Tab
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("MARKETPLACE", style: TextStyle(color: Colors.cyanAccent, letterSpacing: 2)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "BUY ITEMS"),
              Tab(text: "MY INVENTORY"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BuyTab(),       // Tab 1: Toko
            InventoryTab(), // Tab 2: Tas
          ],
        ),
      ),
    );
  }
}

// --- WIDGET TAB 1: TOKO ---
class BuyTab extends StatelessWidget {
  const BuyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final hunter = context.watch<SystemProvider>().hunter;

    final List<Map<String, dynamic>> shopItems = [
      {'icon': '☕', 'name': 'Coffee Break', 'price': 50},
      {'icon': '🎮', 'name': '1 Hour Gaming', 'price': 100},
      {'icon': '🎬', 'name': 'Watch Movie', 'price': 200},
      {'icon': '🍕', 'name': 'Cheat Meal', 'price': 500},
      {'icon': '🛌', 'name': 'Lazy Day', 'price': 1000},
    ];

    return Column(
      children: [
        // Dompet
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber),
              const SizedBox(width: 8),
              Text("${hunter.gold} GOLD", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
            ],
          ),
        ),
        // Grid Toko
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85
            ),
            itemCount: shopItems.length,
            itemBuilder: (context, index) {
              final item = shopItems[index];
              return _buildShopCard(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShopCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item['icon'], style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(item['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("${item['price']} G", style: const TextStyle(color: Colors.amber, fontSize: 12)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              // Panggil fungsi BuyItem yang baru
              final success = context.read<SystemProvider>().buyItem(item['name'], item['icon'], item['price']);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item Purchased! Check Inventory.")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Not enough Gold!")));
              }
            },
            child: const Text("BUY"),
          )
        ],
      ),
    );
  }
}

// --- WIDGET TAB 2: INVENTORY ---
class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final hunter = context.watch<SystemProvider>().hunter;

    if (hunter.inventory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.backpack_outlined, size: 64, color: Colors.grey[800]),
            const SizedBox(height: 16),
            const Text("INVENTORY EMPTY", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hunter.inventory.length,
      itemBuilder: (context, index) {
        final item = hunter.inventory[index];
        return Card(
          color: const Color(0xFF1A1A1A),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(item.icon, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text("Quantity: ${item.quantity}", style: const TextStyle(color: Colors.grey)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent.withOpacity(0.2), foregroundColor: Colors.cyanAccent),
              onPressed: () {
                _showUseConfirmDialog(context, item);
              },
              child: const Text("USE"),
            ),
          ),
        );
      },
    );
  }

  void _showUseConfirmDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0D),
        title: Text("Use ${item.name}?", style: const TextStyle(color: Colors.white)),
        content: const Text("This will consume 1 item. Are you sure?", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL", style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Pakai Item
              context.read<SystemProvider>().useItem(item);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Used ${item.name}. Enjoy!")));
            },
            child: const Text("CONSUME", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}