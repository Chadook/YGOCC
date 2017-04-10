--Lunar Phase Beast: Pegasus Moon Burst
function c4242565.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c4242565.efilter)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	
		--Destroy spell, move grave pend to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242565,3))
	e2:SetCountLimit(1,42425652)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
--	e2:SetCost(c4242565.condition4)
	e2:SetTarget(c4242565.target4)
	e2:SetOperation(c4242565.operation4)
	c:RegisterEffect(e2)
	
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242565,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c4242565.descon1)
	e3:SetTarget(c4242565.destg1)
	e3:SetOperation(c4242565.desop1)
	c:RegisterEffect(e3)

	--Tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242565,3))
	e4:SetCountLimit(1,42425651)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCost(c4242565.descost2)
	e4:SetTarget(c4242565.destg2)
	e4:SetOperation(c4242565.desop2)
	c:RegisterEffect(e4)
	--sp summon 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(4242565,5))
	e6:SetCountLimit(1,42425652)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c4242565.condition3)
	e6:SetTarget(c4242565.target3)
	e6:SetOperation(c4242565.operation3)
	c:RegisterEffect(e6)
end

	--Destroy spell, move grave pend to extra
function c4242565.filter4(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_SPELL) and not c:IsCode(4242565)
end
function c4242565.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM)  --Duel.IsExistingMatchingCard(c4242565.filter4,tp,LOCATION_ONFIELD,0,1,nil)
end
--[[function c4242565.condition4(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c4242565.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
end]]--
function c4242565.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c4242565.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c4242565.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function c4242565.operation4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c4242565.filter4,tp,LOCATION_ONFIELD,0,nil)
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=g:Select(tp,1,1,nil)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
 end
--[[	if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)]]--
end

--atk boost code
function c4242565.efilter(e,c)
 return c:IsSetCard(0x666)
end

--Effect 1 (Search) Code
function c4242565.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242565.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242565.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242565.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242565.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242565.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

--Effect 4 (Special Summon) Code
function c4242565.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(5) and not c:IsLevelBelow(4) and (c:IsSetCard(0x666)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c4242565.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c4242565.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242565.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4242565.desop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4242565.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
--Death replace code
function c4242565.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c4242565.dfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(3) and not c:IsLevelBelow(2) and (c:IsSetCard(0x666)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c4242565.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242565.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c4242565.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4242565.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
