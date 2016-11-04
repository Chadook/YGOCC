--Tag Team
function c32564231.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32564231,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c32564231.eqtg)
	e2:SetOperation(c32564231.eqop)
	c:RegisterEffect(e2)
	--Add to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32564231,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c32564231.thtg)
	e3:SetOperation(c32564231.thop)
	c:RegisterEffect(e3)
end
function c32564231.filter1(c,tp)
	return c:IsType(TYPE_UNION) and Duel.IsExistingTarget(c32564231.filter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function c32564231.filter2(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c32564231.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c32564231.filter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32564231,2))
	local g1=Duel.SelectTarget(tp,c32564231.filter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c32564231.filter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst())
	e:SetLabelObject(g1:GetFirst())
end
function c32564231.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsLocation(LOCATION_HAND) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) and Duel.Equip(tp,tc1,tc2,true) then 
		tc1:SetStatus(STATUS_UNION,true)
	end
end
function c32564231.cfilter(c)
	return c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c32564231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c32564231.cfilter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c32564231.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c32564231.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end