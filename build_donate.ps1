$lines = Get-Content index.html
$top = $lines[0..485]
$bottom = $lines[1072..($lines.Length-1)]

$middle = @"
    <!-- Donation Section -->
    <section id="donate-section" class="bg-charcoal tex-charcoal diagonal-slash" data-theme="dark" style="min-height: 100vh; padding-top: 150px;">
        <div class="grain-overlay"></div>
        <div class="container" style="max-width: 800px;">
            <div class="reveal active" style="text-align: center; margin-bottom: 3rem;">
                <span class="sec-tag">[ SUPPORT US ]</span>
                <h2 class="sec-title" style="color: var(--ivory);">Make a Donation</h2>
                <div class="gold-rule" style="margin: 2rem auto;"></div>
                <p style="color: rgba(255,255,255,0.7);">Your contribution directly supports grassroots sports and education for youth across India.</p>
            </div>

            <div class="donate-card" style="background: var(--charcoal-mid); border-radius: 6px; border-top: 3px solid var(--gold); padding: 3rem; box-shadow: 0 20px 40px rgba(0,0,0,0.4);">
                
                <h3 style="font-family: 'Cormorant Garamond'; color: var(--ivory); font-size: 1.5rem; margin-bottom: 1.5rem;">Select Amount</h3>
                <div style="display: flex; gap: 1rem; margin-bottom: 2rem; flex-wrap: wrap;">
                    <button type="button" class="supp-pill amt-btn active" style="flex: 1; padding: 15px; font-size: 1.1rem; background: var(--emerald); color: var(--ivory);" data-amt="500">₹500</button>
                    <button type="button" class="supp-pill amt-btn" style="flex: 1; padding: 15px; font-size: 1.1rem;" data-amt="1000">₹1000</button>
                    <button type="button" class="supp-pill amt-btn" style="flex: 1; padding: 15px; font-size: 1.1rem;" data-amt="2500">₹2500</button>
                    <button type="button" class="supp-pill amt-btn" style="flex: 1; padding: 15px; font-size: 1.1rem;" data-amt="5000">₹5000</button>
                </div>
                
                <div style="margin-bottom: 2.5rem;">
                    <label style="font-family: 'Courier Prime'; color: var(--gold); font-size: 12px; letter-spacing: 2px;">OR ENTER CUSTOM AMOUNT</label>
                    <input type="number" id="custom-amt" placeholder="Enter amount in ₹" style="width: 100%; background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); color: var(--ivory); padding: 15px; border-radius: 4px; margin-top: 10px; font-size: 1.1rem; font-family: sans-serif;">
                </div>

                <h3 style="font-family: 'Cormorant Garamond'; color: var(--ivory); font-size: 1.5rem; margin-bottom: 1.5rem;">Your Details</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.5rem;">
                    <div>
                        <input type="text" id="donor-name" placeholder="Full Name" style="width: 100%; background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); color: var(--ivory); padding: 15px; border-radius: 4px; font-size: 1rem;">
                    </div>
                    <div>
                        <input type="email" id="donor-email" placeholder="Email Address" style="width: 100%; background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); color: var(--ivory); padding: 15px; border-radius: 4px; font-size: 1rem;">
                    </div>
                </div>
                <div style="margin-bottom: 3rem;">
                    <input type="text" id="donor-phone" placeholder="Phone Number" style="width: 100%; background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); color: var(--ivory); padding: 15px; border-radius: 4px; font-size: 1rem;">
                </div>

                <button onclick="processDonation()" class="btn-donate-large" style="width: 100%; border: none; cursor: pointer;">PROCEED TO PAY &rarr;</button>
            </div>
        </div>
    </section>

    <!-- Razorpay Integration -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
        let selectedAmount = 500;
        
        const amtBtns = document.querySelectorAll('.amt-btn');
        const customAmt = document.getElementById('custom-amt');
        
        amtBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                amtBtns.forEach(b => {
                    b.style.background = 'transparent';
                    b.style.color = 'var(--emerald)';
                });
                btn.style.background = 'var(--emerald)';
                btn.style.color = 'var(--ivory)';
                selectedAmount = parseInt(btn.getAttribute('data-amt'));
                customAmt.value = '';
            });
        });
        
        customAmt.addEventListener('input', (e) => {
            if(e.target.value) {
                selectedAmount = parseInt(e.target.value);
                amtBtns.forEach(b => {
                    b.style.background = 'transparent';
                    b.style.color = 'var(--emerald)';
                });
            }
        });

        function processDonation() {
            const name = document.getElementById('donor-name').value;
            const email = document.getElementById('donor-email').value;
            const phone = document.getElementById('donor-phone').value;
            
            if(!selectedAmount || selectedAmount < 1) {
                alert("Please enter a valid amount.");
                return;
            }
            
            var options = {
                "key": "YOUR_RAZORPAY_KEY_ID_HERE", 
                "amount": selectedAmount * 100, 
                "currency": "INR",
                "name": "VEER SPORTS FOUNDATION",
                "description": "Donation for Youth Sports & Education",
                "image": "images/logo.jpg",
                "handler": function (response){
                    alert("Thank you for your donation, " + (name || 'Friend') + "! Payment ID: " + response.razorpay_payment_id);
                },
                "prefill": {
                    "name": name,
                    "email": email,
                    "contact": phone
                },
                "theme": {
                    "color": "#1F8A70"
                }
            };
            var rzp1 = new Razorpay(options);
            rzp1.on('payment.failed', function (response){
                    alert("Payment Failed. Reason: " + response.error.description);
            });
            rzp1.open();
        }
    </script>
"@

$top | Set-Content donate.html
$middle | Add-Content donate.html
$bottom | Add-Content donate.html
