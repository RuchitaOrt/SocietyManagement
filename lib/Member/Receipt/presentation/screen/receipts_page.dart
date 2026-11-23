
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/Receipt/presentation/bloc/receipts_bloc.dart';
import 'package:society_management/Member/Receipt/presentation/bloc/receipts_event.dart';
import 'package:society_management/Member/Receipt/presentation/bloc/receipts_state.dart';
import 'package:society_management/Member/Receipt/presentation/data/repository/receipt_repository.dart';
import 'package:society_management/Member/Receipt/presentation/widget/receipt/receipt_card.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';



class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReceiptsBloc(ReceiptRepository())
        ..add(LoadReceipts()),
      child: const ReceiptsView(),
    );
  }
}

class ReceiptsView extends StatefulWidget {
  const ReceiptsView({super.key});

  @override
  State<ReceiptsView> createState() => _ReceiptsViewState();
}

class _ReceiptsViewState extends State<ReceiptsView> {
  final searchController = TextEditingController();

  static const primary = Color(0xFFEF1685);
  static const navy = Color(0xFF18264B);
  static const muted = Color(0xFF8793AA);

  final months = [
    'All Months',
    'November 2026',
    'October 2026',
    'September 2026',
    'August 2026',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: AdminColors.page,

      // APP BAR UNCHANGED
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  const LinearGradient(
                colors: [
                  Color(0xFFEC4899),
                  Color(0xFFF97316),
                ],
              ).createShader(bounds),
              child: const Text(
                'Receipts',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Track your payment receipts | Ruchita | Flat 201 | A',
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
        actions: [],
      ),

      body: SafeArea(
        child: Column(
          children: [
           
            Expanded(
              child: BlocBuilder<ReceiptsBloc, ReceiptsState>(
                builder: (context, state) {
                  if (state.status == ReceiptsStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primary,
                      ),
                    );
                  }

                  if (state.status == ReceiptsStatus.failure) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.errorMessage ?? 'Unable to load receipts',
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ReceiptsBloc>().add(
                                LoadReceipts(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final receipts = state.filteredReceipts;

                  return RefreshIndicator(
                    color: primary,
                    onRefresh: () async {
                      context.read<ReceiptsBloc>().add(
                        RefreshReceipts(),
                      );
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        18, 18, 18, 25,
                      ),
                      children: [
                        _buildSearch(context),
                        const SizedBox(height: 15),
                        _buildMonthFilter(context, state),
                        const SizedBox(height: 23),

                        Row(
                          children: [
                            const Text(
                              'Payment History',
                              style: TextStyle(
                                color: navy,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${receipts.length} receipts',
                              style: const TextStyle(
                                color: muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        if (receipts.isEmpty)
                          _buildEmptyState()
                        else
                          ...receipts.map(
                            (receipt) => ReceiptCard(
                              receipt: receipt,
                              onTap: () {
                                _showReceiptDetails(receipt);
                              },
                            ),
                          ),
                      ],
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


  Widget _buildSearch(BuildContext context) {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EAF1)),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          context.read<ReceiptsBloc>().add(
            SearchReceipts(value),
          );
        },
        decoration: InputDecoration(
          hintText: 'Search receipts...',
          hintStyle: const TextStyle(
            fontSize: 13,
            color: muted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: muted,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    context.read<ReceiptsBloc>().add(
                      SearchReceipts(''),
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.close, size: 18),
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMonthFilter(
    BuildContext context,
    ReceiptsState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8EAF1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedMonth,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: primary,
          ),
          style: const TextStyle(
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          items: months.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<ReceiptsBloc>().add(
                FilterReceiptsByMonth(value),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE8F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 35,
              color: primary,
            ),
          ),
          const SizedBox(height: 17),
          const Text(
            'No Receipts Found',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Your payment receipts will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showReceiptDetails(receipt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Receipt Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _detailRow('Receipt No.', receipt.receiptNumber),
                _detailRow('Bill No.', receipt.billNumber),
                _detailRow('Date', receipt.date),
                _detailRow('Payment Mode', receipt.paymentMode),
                _detailRow(
                  'Amount',
                  '₹${receipt.amount.toStringAsFixed(2)}',
                ),
                _detailRow('Status', receipt.status),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
