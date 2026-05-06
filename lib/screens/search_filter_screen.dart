import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Statuses';

  final List<String> _statuses = ['All Statuses', 'Available', 'Low Stock', 'Out of Stock'];

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productProvider);

    // Extract unique categories from products
    final categories = ['All Categories', ...allProducts.map((p) => p.category).toSet()];

    // Apply filters
    final filteredProducts = allProducts.where((product) {
      // 1. Search Query
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // 2. Category
      final matchesCategory = _selectedCategory == 'All Categories' || product.category == _selectedCategory;
      
      // 3. Status
      bool matchesStatus = true;
      if (_selectedStatus == 'Available') {
        matchesStatus = product.quantity > product.threshold;
      } else if (_selectedStatus == 'Low Stock') {
        matchesStatus = product.quantity > 0 && product.quantity <= product.threshold;
      } else if (_selectedStatus == 'Out of Stock') {
        matchesStatus = product.quantity == 0;
      }

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: categories.contains(_selectedCategory) ? _selectedCategory : 'All Categories',
                    decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    items: categories.map<DropdownMenuItem<String>>((c) => DropdownMenuItem<String>(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: _statuses.map<DropdownMenuItem<String>>((s) => DropdownMenuItem<String>(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                    onChanged: (val) => setState(() => _selectedStatus = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('No products match your search.', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final isCritical = product.quantity == 0;
                        final isLow = product.quantity <= product.threshold && !isCritical;
                        
                        Color statusColor = Colors.green;
                        if (isCritical) statusColor = Colors.red;
                        else if (isLow) statusColor = Colors.orange;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: statusColor,
                              child: Icon(Icons.inventory, color: Colors.white, size: 20),
                            ),
                            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Category: ${product.category}'),
                            trailing: Text('${product.quantity} qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
