--Bunkia,Vampire of Magnificent Vine 
--Created by Chadook
--Scripted By Chadook
-- Even tho there isn't much to code to be honest.. :p
function c160002213.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160002213.splimit)
	e2:SetCondition(c160002213.splimcon)
	c:RegisterEffect(e2)
		--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160002213,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160002214)
	e3:SetCondition(c160002213.condition)
	e3:SetTarget(c160002213.target)
	e3:SetOperation(c160002213.operation)
	c:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160002213,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
		e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,160002213)
	e4:SetTarget(c160002213.sptg)
	e4:SetOperation(c160002213.spop)
	c:RegisterEffect(e4)
			--leave field
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c160002213.leave)
	c:RegisterEffect(e6)
	e4:SetLabelObject(e6)

end
function c160002213.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x785c)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160002213.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160002213.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x785c)
end
function c160002213.filter(c,tp)
	return c:IsSetCard(0x785c) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c160002213.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160002213.filter,1,nil,tp)
end
function c160002213.exfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785c) and c:IsAbleToHand()
end
function c160002213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160002213.exfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c160002213.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160002213.exfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c160002213.spfilter(c,e,tp)
	return c:IsSetCard(0x785c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160002213.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c160002213.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160002213.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160002213.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160002213.spop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:GetLabelObject():SetLabelObject(tc)
		c:CreateRelation(tc,RESET_EVENT+0x5020000)
		tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
	end
end
function c160002213.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end