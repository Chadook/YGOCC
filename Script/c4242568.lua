--Lunar Phase: Moon Burst the Forgotten Child
function c4242568.initial_effect(c)
	 --pendulum summon
 aux.EnablePendulumAttribute(c)
		--search if deal damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12152769,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,4242568)
	e1:SetCondition(c4242568.condition)
	e1:SetTarget(c4242568.target)
	e1:SetOperation(c4242568.operation)
	c:RegisterEffect(e1)
	--Damage during standby
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242568,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,42425681)
	e2:SetCondition(c4242568.conditiond)
	e2:SetCost(c4242568.dmcost)
	e2:SetTarget(c4242568.dmtg)
	e2:SetOperation(c4242568.dmop)
	c:RegisterEffect(e2)
	
		--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242568,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c4242568.descon1)
	e4:SetTarget(c4242568.destg1)
	e4:SetOperation(c4242568.desop1)
	c:RegisterEffect(e4)
end
--search tiny pony
function c4242568.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242568.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242568.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242568.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242568.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242568.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--Damage during standby
function c4242568.counterfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c4242568.conditiond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c4242568.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(4242568,tp,ACTIVITY_SPSUMMON)==0 end

end
function c4242568.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666)
end
function c4242568.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242568.dmfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(c4242568.dmfilter,tp,LOCATION_EXTAR,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*300
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c4242568.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(c4242568.dmfilter,tp,LOCATION_EXTRA,0,nil)
		local dam=g:GetClassCount(Card.GetCode)*300
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
--search if deal damage
function c4242568.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c4242568.filter2(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) and not c:IsLevelBelow(3)
end
function c4242568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4242568.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4242568.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

	
	
	
	
	
	
	
	
	
	