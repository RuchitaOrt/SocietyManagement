
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/ParkingSLot/Presentation/Bloc/parking_slot_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/ParkingSlotModel.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/ParkingSlot.dart/add_parking_slot_bottom_sheet.dart';


const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);

class ParkingSlotScreen extends StatelessWidget {
  const ParkingSlotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingSlotBloc(),
      child: const _ParkingSlotView(),
    );
  }
}

class _ParkingSlotView extends StatefulWidget {
  const _ParkingSlotView();

  @override
  State<_ParkingSlotView> createState() =>
      _ParkingSlotViewState();
}

class _ParkingSlotViewState extends State<_ParkingSlotView> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  // Temporary society configuration.
  // Later connect these values with your society setup BLoC.
  final List<String> _wings = ['A', 'B', 'C'];

  final Map<String, List<String>> _flatsByWing = {
    'A': ['101', '102', '103', '104'],
    'B': ['201', '202', '203', '204'],
    'C': ['301', '302', '303', '304'],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // OPEN ADD PARKING SLOT BOTTOM SHEET

  Future<void> _openAddParkingSlot() async {
    final slot = await showAddParkingSlotBottomSheet(
      context,
      wings: _wings,
      flatsByWing: _flatsByWing,
      initialWing: 'A',
    );

    if (!mounted || slot == null) return;

    context.read<ParkingSlotBloc>().add(
      ParkingSlotCreated(slot),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Parking slot added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // SEARCH

  List<ParkingSlotModel> _filterSlots(
    List<ParkingSlotModel> slots,
  ) {
    if (_searchQuery.trim().isEmpty) return slots;

    final query = _searchQuery.toLowerCase().trim();

    return slots.where((slot) {
      return slot.wing.toLowerCase().contains(query) ||
          slot.flatNumber.toLowerCase().contains(query) ||
          slot.slotNumber.toLowerCase().contains(query) ||
          slot.slotType.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor:  AdminColors.page,
       floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: _openAddParkingSlot,
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add Parking Slot',
        style: TextStyle(color: Colors.white),
      ),
    ),
    
  ],
),
     appBar: AppBar(
  title: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFEC4899),
            Color(0xFFF97316),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
         'Paarking Slots',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
        
 
      const SizedBox(height: 3),
      Text(
        'Manage all society parking slots',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  ),
 
  backgroundColor: AdminColors.page,
  elevation: 0,
  actions: [
    IconButton(
      onPressed: () {
        // TODO: Navigate to Notifications Screen
      },
      icon: const Icon(
        Icons.notifications_none_rounded,
        color: Color(0xFFEC4899),
        size: 25,
      ),
      tooltip: 'Notifications',
    ),
    const SizedBox(width: 6),
  ],
),
      body: BlocBuilder<ParkingSlotBloc, ParkingSlotState>(
        builder: (context, state) {
          final filteredSlots = _filterSlots(state.slots);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 

                  const SizedBox(height: 18),

                  // SUMMARY CARDS
                  _buildSummaryCards(state),

                
                  // SEARCH
                  _buildSearchAndAdd(),

                  const SizedBox(height: 16),

                  // PARKING SLOT TABLE
                 // PARKING SLOT CARDS
_buildParkingSlotCards(
  filteredSlots,
  state.slots,
),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // HEADER


  // SUMMARY CARDS

  Widget _buildSummaryCards(ParkingSlotState state) {
    final cards = [
      _ParkingSummaryData(
        'Total Slots',
        state.totalSlots,
        Icons.local_parking_outlined,
        Colors.blue,
      ),
      _ParkingSummaryData(
        '2-Wheeler',
        state.twoWheelerCount,
        Icons.two_wheeler,
        Colors.orange,
      ),
      _ParkingSummaryData(
        '4-Wheeler',
        state.fourWheelerCount,
        Icons.directions_car_outlined,
        const Color(0xFFE93691),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final item = cards[index];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.count}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                      ),
                    ),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // SEARCH AND ADD BUTTON

  Widget _buildSearchAndAdd() {
    return LayoutBuilder(
      builder: (context, constraints) {
     
        final searchField = SizedBox(
          height: 44,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: 'Search parking slots...',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFF91A0B8),
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 19,
                color: Color(0xFF91A0B8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE3EF),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE3EF),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: _primaryColor,
                ),
              ),
            ),
          ),
        );

        

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchField,
            
           
          ],
        );
      },
    );
  }

  // PARKING SLOT TABLE

Widget _buildParkingSlotCards(
  List<ParkingSlotModel> filteredSlots,
  List<ParkingSlotModel> allSlots,
) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: Colors.grey.shade100,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE8F1),
                Color(0xFFFFEBD8),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(14),
            ),
          ),
          child: const Text(
            'Parking Slot List',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
        ),

        // EMPTY STATE
        if (filteredSlots.isEmpty)
          _buildEmptyState(allSlots.isEmpty)

        // PARKING SLOT CARDS
        else
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                filteredSlots.length,
                (index) {
                  final slot = filteredSlots[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildParkingSlotCard(
                      slot,
                      index,
                    ),
                  );
                },
              ),
            ),
          ),

        // FOOTER
        if (filteredSlots.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Text(
              'Showing 1-${filteredSlots.length} of ${allSlots.length}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ),
      ],
    ),
  );
}

// INDIVIDUAL PARKING SLOT CARD

Widget _buildParkingSlotCard(
  ParkingSlotModel slot,
  int index,
) {
  final isTwoWheeler = slot.slotType == '2-Wheeler';

  final Color typeColor = isTwoWheeler
      ? Colors.orange
      : const Color(0xFFE93691);

  return Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFE8EDF4),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOP ROW
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                isTwoWheeler
                    ? Icons.two_wheeler
                    : Icons.directions_car_outlined,
                color: typeColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.slotNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Parking Slot ${index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            _buildSlotTypeBadge(slot.slotType),

            const SizedBox(width: 5),

            IconButton(
              tooltip: 'Delete',
              visualDensity: VisualDensity.compact,
              onPressed: () => _confirmDelete(slot),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Divider(
          height: 1,
          color: Colors.grey.shade100,
        ),

        const SizedBox(height: 12),

        // SLOT DETAILS
        Row(
          children: [
            Expanded(
              child: _parkingDetail(
                Icons.apartment_outlined,
                'Wing',
                slot.wing,
              ),
            ),

            Expanded(
              child: _parkingDetail(
                Icons.home_outlined,
                'Flat Number',
                slot.flatNumber,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _parkingDetail(
                Icons.local_parking_outlined,
                'Slot Number',
                slot.slotNumber,
              ),
            ),

            Expanded(
              child: _parkingDetail(
                Icons.directions_car_outlined,
                'Vehicle Type',
                slot.slotType,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// PARKING DETAIL ITEM

Widget _parkingDetail(
  IconData icon,
  String title,
  String value,
) {
  return Row(
    children: [
      Icon(
        icon,
        size: 15,
        color: const Color(0xFF91A0B8),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF91A0B8),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  // SLOT TYPE BADGE

  Widget _buildSlotTypeBadge(String type) {
    final isTwoWheeler = type == '2-Wheeler';

    final color = isTwoWheeler
        ? Colors.blue
        : const Color(0xFF16A34A);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // EMPTY STATE

  Widget _buildEmptyState(bool isCompletelyEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              isCompletelyEmpty
                  ? Icons.local_parking_outlined
                  : Icons.search_off,
              size: 42,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCompletelyEmpty
                ? 'No Parking Slots Added'
                : 'No Matching Parking Slots Found',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            isCompletelyEmpty
                ? 'Click Add Parking Slot to create your first slot.'
                : 'Try searching with another keyword.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // DELETE CONFIRMATION

  void _confirmDelete(ParkingSlotModel slot) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Parking Slot'),
          content: Text(
            'Are you sure you want to delete ${slot.slotNumber}?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<ParkingSlotBloc>().add(
                  ParkingSlotDeleted(slot),
                );

                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// SUMMARY MODEL

class _ParkingSummaryData {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  _ParkingSummaryData(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}
