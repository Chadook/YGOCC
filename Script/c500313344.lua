function c500313344.initial_effect(c)
c:EnableReviveLimit()
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500313344,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,500313344)
	e2:SetCost(c500313344.thcost)
	e2:SetTarget(c500313344.thtg)
	e2:SetOperation(c500313344.thop)
	c:RegisterEffect(e2)

		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500313344,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1500313345)
	e1:SetCost(c500313344.cost)
	e1:SetTarget(c500313344.target)
	e1:SetOperation(c500313344.operation)
	c:RegisterEffect(e1)
	
end
function c500313344.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c500313344.thfilter(c)
	return c:IsSetCard(0x785a)  and c:IsAbleToHand()
end
function c500313344.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500313344.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c500313344.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500313344.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
 Duel.ConfirmCards(1-tp,g)
end
end
function c500313344.filter(c,tp,ep,val)
local atk=c:GetAttack()
	return atk>=0 and atk<val
and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() 
		and ep~=tp and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c500313344.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(c500313344.filter,1,nil,tp,ep,e:GetHandler():GetAttack())
end
function c500313344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c500313344.target(e,tp,eg,ep,ev,re,r,rp,chk)
local tc=eg:GetFirst()
	if chk==0 then return c500313344.filter(tc,tp,ep,e:GetHandler():GetAttack()) end
	Duel.SetTargetCard(eg)
end
function c500313344.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
		local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
end
end